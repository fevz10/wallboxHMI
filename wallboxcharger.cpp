#include "wallboxcharger.h"

WallboxCharger::WallboxCharger(QObject *parent) : QObject(parent)
{
    bool ret;
    if (!initializeDatabase(db, databasePath))
    {
        qDebug() << "Error!";
    }
    jSON_ConfigRead();
#ifdef CAN_ENABLE
    ret = CAN_Init();
    if (false == ret)
    {
        return;
    }
#endif

    ret = openFifo();
    if (false == ret)
    {
        return;
    }
    getNetworkInfo();
}

WallboxCharger::~WallboxCharger()
{
    if (notifier)
    {
        delete notifier;
    }
    fifoFile.close();
#ifdef CAN_ENABLE
    if(canDevice)
    {
        canDevice->disconnectDevice();
    }
#endif
}

bool WallboxCharger::openFifo(void)
{
    QString fifoPath = "/tmp/myfifo";
    fifoFile.setFileName(fifoPath);
    if (!fifoFile.open(QIODevice::ReadOnly | QIODevice::Unbuffered))
    {
        qDebug() << "Error: Failed to open FIFO file";
        return false;
    }
    notifier = new QSocketNotifier(fifoFile.handle(), QSocketNotifier::Read, this);
    connect(notifier, &QSocketNotifier::activated, this, &WallboxCharger::onDataAvailable);
    return true;
}

void WallboxCharger::onDataAvailable()
{
    QByteArray buf = fifoFile.readAll();
    QString remoteOperation;
    if (!buf.isEmpty())
    {
        remoteOperation = QString::fromStdString(buf.toStdString());
        if(remoteOperation.contains("RemoteStart"))
        {
            isRemoteStart = 0x01;
            emit notify();
        }
        if(remoteOperation.contains("RemoteStop"))
        {
            isRemoteStop = 0x01;
            emit notify();
        }
    }
}

bool WallboxCharger::isOCPPProcessRunning(void)
{
    std::string command = "pidof ocpp_client";
    FILE* pipe = popen(command.c_str(), "r");
    if (!pipe)
    {
        qDebug() << "Error: Unable to execute command.";
        return false;
    }
    char buffer[128];
    while (!feof(pipe))
    {
        if (fgets(buffer, 128, pipe) != NULL)
        {
            pclose(pipe);
            return true;
        }
    }
    pclose(pipe);
    return false;
}

bool WallboxCharger::isRFIDTagSuccess(void)
{
    if(RFID_uuid.compare("0000000000") == 0)
    {
        return false;
    }
    else
    {
        return true;
    }
}

bool WallboxCharger::checkNetworkConnection(void)
{
    bool retVal = false;
    QNetworkAccessManager nam;
    QNetworkRequest req(QUrl("http://www.google.com"));
    QNetworkReply* reply = nam.get(req);
    QEventLoop loop;
    QTimer timeoutTimer;

    connect(&timeoutTimer, SIGNAL(timeout()), &loop, SLOT(quit()));
    connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));

    timeoutTimer.setSingleShot(true);
    timeoutTimer.start(1000);
    loop.exec();

    if (reply->bytesAvailable())
    {
        retVal = true;
    }

    return retVal;
}

void WallboxCharger::resetRemoteOperations()
{
    isRemoteStart = 0x00;
    isRemoteStop = 0x00;
}

void WallboxCharger::getNetworkInfo(void)
{
    QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();

    foreach (QNetworkInterface iface, interfaces)
    {
        if (iface.name() == "eth0")
        {
            qDebug() << "MAC Address of eth0:" << iface.hardwareAddress();
            MACaddr = iface.hardwareAddress();
            QList<QNetworkAddressEntry> entries = iface.addressEntries();
            foreach (QNetworkAddressEntry entry, entries)
            {
                if (entry.ip().protocol() == QAbstractSocket::IPv4Protocol)
                {
                    qDebug() << "IPv4 Address of eth0:" << entry.ip().toString();
                    IPaddr = entry.ip().toString();
                }
            }
            emit notify();
        }
    }
}

void WallboxCharger::jSON_ConfigUpdate(QVariant domain, QVariant port, QVariant path, QVariant cpId, QVariant qrText)
{
    QFile file(configJSONFilename);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    QJsonParseError jsonParseError;
    QJsonDocument jsonDocument = QJsonDocument::fromJson(file.readAll(), &jsonParseError);
    file.close();
    QJsonObject rootObject = jsonDocument.object();

    QJsonValueRef refDomain = rootObject.find("OCPP_Server_Host").value();
    QJsonObject m_addValueDomain = refDomain.toObject();
    refDomain = domain.toString();

    QJsonValueRef refPort = rootObject.find("OCPP_Server_Port").value();
    QJsonObject m_addValuePort = refPort.toObject();
    refDomain = port.toInt();

    QJsonValueRef refPath = rootObject.find("OCPP_Server_Path").value();
    QJsonObject m_addValuePath = refPath.toObject();
    refPath = path.toString();

    QJsonValueRef refCPid = rootObject.find("CP_ID").value();
    QJsonObject m_addValueCPid = refCPid.toObject();
    refPath = cpId.toString();

    QJsonValueRef refQRtext = rootObject.find("CP_QRtext").value();
    QJsonObject m_addValueQRText = refQRtext.toObject();
    refPath = qrText.toString();

    jsonDocument.setObject(rootObject);
    file.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    file.write(jsonDocument.toJson());
    file.close();
}

void WallboxCharger::jSON_ConfigRead()
{
    QString val;
    QFile file;
    file.setFileName(configJSONFilename);
    file.open(QIODevice::ReadOnly | QIODevice::Text);
    val = file.readAll();

    file.close();
    QJsonDocument d = QJsonDocument::fromJson(val.toUtf8());
    QJsonObject rootJSON = d.object();

    QJsonValue ocppServerHostJSON = rootJSON.value(QString("OCPP_Server_Host"));
    qDebug() << "OCPP_Server_Host : " << ocppServerHostJSON.toString();
    serverHost = ocppServerHostJSON.toString();

    QJsonValue ocppServerPortJSON = rootJSON.value(QString("OCPP_Server_Port"));
    qDebug() << "OCPP_Server_Port : " << ocppServerPortJSON.toInt();
    serverPort = ocppServerPortJSON.toInt();

    QJsonValue ocppServerPathJSON = rootJSON.value(QString("OCPP_Server_Path"));
    qDebug() << "OCPP_Server_Path : " << ocppServerPathJSON.toString();
    serverPath = ocppServerPathJSON.toString();

    QJsonValue offlineModeJSON = rootJSON.value(QString("OfflineMode"));
    qDebug() << "OfflineMode : " << offlineModeJSON.toBool();
    offlineMode = offlineModeJSON.toBool();

    QJsonValue autoChargeJSON = rootJSON.value(QString("AutoCharge"));
    qDebug() << "AutoCharge : " << autoChargeJSON.toBool();
    autoCharge = autoChargeJSON.toBool();

    QJsonValue qrTextJSON = rootJSON.value(QString("CP_QRtext"));
    qDebug() << "QR Text : " << qrTextJSON.toString();
    qrText = qrTextJSON.toString();

    QJsonValue adminPasswordJSON = rootJSON.value(QString("AdminPassword"));
    qDebug() << "Admin Password : " << adminPasswordJSON.toString();
    adminPassword = adminPasswordJSON.toString();

    QJsonValue CPIDJSON = rootJSON.value(QString("CP_ID"));
    qDebug() << "CP ID : " << CPIDJSON.toString();
    CP_ID = CPIDJSON.toString();

    emit notify();
}

bool WallboxCharger::initializeDatabase(QSqlDatabase &db, const QString &dbPath)
{
    db = QSqlDatabase::addDatabase("QSQLITE"); // Using SQLite as the database
    db.setDatabaseName(dbPath);

    if (!db.open()) {
        qDebug() << "Error: Unable to open database!";
        return false;
    }

    QSqlQuery query;
    QString createTableQuery = "CREATE TABLE IF NOT EXISTS rfid_table ("
                                "id INTEGER PRIMARY KEY AUTOINCREMENT,"
                                "uid TEXT UNIQUE NOT NULL)";

    if (!query.exec(createTableQuery)) {
        qDebug() << "Error creating table:" << query.lastError().text();
        return false;
    }

    return true;
}

bool WallboxCharger::addRFID(const QVariant uid)
{
    QSqlQuery query;
    query.prepare("INSERT INTO rfid_table (uid) VALUES (:uid)");
    query.bindValue(":uid", uid);

    if (!query.exec())
    {
        qDebug() << "Error adding RFID:" << query.lastError().text();
        return false;
    }

    qDebug() << "RFID added successfully!";
    return true;
}

bool WallboxCharger::searchRFID(const QVariant uid)
{
    QSqlQuery query;
    query.prepare("SELECT * FROM rfid_table WHERE uid = :uid");
    query.bindValue(":uid", uid);

    if (!query.exec())
    {
        qDebug() << "Error searching RFID:" << query.lastError().text();
        return false;
    }

    if (query.next())
    {
        qDebug() << "RFID found:" << query.value("uid").toString();
        return true;
    }
    else
    {
        qDebug() << "RFID not found.";
        return false;
    }
}

bool WallboxCharger::deleteRFID(const QVariant uid)
{
    QSqlQuery query;
    query.prepare("DELETE FROM rfid_table WHERE uid = :uid");
    query.bindValue(":uid", uid);

    if (!query.exec())
    {
        qDebug() << "Error deleting RFID:" << query.lastError().text();
        return false;
    }

    qDebug() << "RFID deleted successfully!";
    return true;
}

void WallboxCharger::buzzerOff(void)
{
    const char* command = "echo -e -n \"\\x5A\\xA5\\x03\\x03\\x00\\x06\" > /dev/ttyS1";
    std::system(command);
}

void WallboxCharger::buzzerOn(void)
{
    const char* command = "echo -e -n \"\\x5A\\xA5\\x03\\x03\\xFF\\x05\" > /dev/ttyS1";
    std::system(command);
}

void WallboxCharger::wrongRFID(void)
{
    buzzerOn();
    QThread::msleep(1000);
    buzzerOff();
}

void WallboxCharger::trueRFID(void)
{
    buzzerOn();
    QThread::msleep(50);
    buzzerOff();
    QThread::msleep(50);
    buzzerOn();
    QThread::msleep(50);
    buzzerOff();
    QThread::msleep(50);
}

#ifdef CAN_ENABLE

bool WallboxCharger::CAN_Init(void)
{
    canDevice = QCanBus::instance()->createDevice(QStringLiteral("socketcan"), QStringLiteral("can0"), &errorString);
    if(!canDevice)
    {
        qDebug() << "CAN INIT ERROR : " << errorString;
        return false;
    }
    else
    {
        canDevice->connectDevice();
        qDebug() << "CAN INIT OK!";
    }
    connect(canDevice, &QCanBusDevice::framesReceived, this, &WallboxCharger::CANReceive);
    qDebug() << "CAN Receiving Slot is started";
    return true;
}

void WallboxCharger::CANReceive(void)
{
    if(!canDevice)
    {
        return;
    }
    while( canDevice->framesAvailable() )
    {
        const QCanBusFrame frame = canDevice->readFrame();
        quint32 id;
        if( frame.frameType() == QCanBusFrame::DataFrame )
        {
            id = frame.frameId();
            const auto &payload = frame.payload();
            // qDebug() << "Received frame id : " << id;
            switch(id)
            {
            /*
            case 291:
                EVPresentVoltage = (uint16_t)( ( (uint8_t)payload[1] << 8) | (uint8_t)payload[0] );
                EVSOC = (uint16_t)( ( (uint8_t)payload[3] << 8) | (uint8_t)payload[2] );
                EVSOC = mapValue(EVSOC, 0, 4095, 0, 100);
                EVPresentVoltage = mapValue(EVPresentVoltage, 0, 4095, 0, 400);
                EVPresentCurrent = 100.6;
                EVPower = EVPresentVoltage * EVPresentCurrent;
                EVChargeState = payload[4] & 0x01;
                EVPlugState = payload[5] & 0x01;

                EVElapsedChargeTime = 0;
                EVDeliveredEnergy = 1002.5;

                voltage_str = QString::number(EVPresentVoltage, 'f', 2);
                current_str = QString::number(EVPresentCurrent, 'f', 2);
                power_str = QString::number(EVPower/1000, 'f', 2);
                energy_str = QString::number(EVDeliveredEnergy, 'f', 2);
                timestamp_str = QDateTime::fromTime_t(EVElapsedChargeTime).toString("hh:mm:ss");

                emit notify();
                break;
            */
            case 1:
                //sprintf(RFID_uuid, "%02X%02X%02X%02X%02X", payload[0], payload[1], payload[2], payload[3], payload[4]);
                RFID_uuid.sprintf("%02X%02X%02X%02X%02X",payload[0], payload[1], payload[2], payload[3], payload[4]);
                emit notify();
                break;
            case 1536:
                EVChargeState = payload[0];
                EVPlugState = ((uint8_t)(payload[3] & 0x38)>>3);
                emit notify();
                break;
            case 1537:
                EVPresentVoltage = ( (uint16_t)( ( (uint8_t)payload[1] << 8) | (uint8_t)payload[0] ) * 0.1 );
                EVPresentCurrent = ( (uint16_t)( ( (uint8_t)payload[3] << 8) | (uint8_t)payload[2] ) * 0.1 ) - 1000;
                EVPower = EVPresentVoltage * EVPresentCurrent;
                voltage_str = QString::number(EVPresentVoltage, 'f', 2);
                current_str = QString::number(EVPresentCurrent, 'f', 2);
                power_str = QString::number(EVPower/1000, 'f', 2);
                emit notify();
                break;
            case 1538:
                EVElapsedChargeTime = (uint32_t)( ((uint8_t)payload[3] << 24) | ((uint8_t)payload[2] << 16) | ((uint8_t)payload[1] << 8) | ((uint8_t)payload[0]) );
                EVDeliveredEnergy = ( (uint32_t)( ((uint8_t)payload[7] << 24) | ((uint8_t)payload[6] << 16) | ((uint8_t)payload[5] << 8) | ((uint8_t)payload[4]) ) * 0.001);
                energy_str = QString::number(EVDeliveredEnergy, 'f', 2);
                timestamp_str = QDateTime::fromTime_t(EVElapsedChargeTime).toString("hh:mm:ss");
                emit notify();
                break;
            case 353435655:
                EVSOC = payload[2];
                emit notify();
                break;
            }
        }
    }
}

#endif
