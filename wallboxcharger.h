#ifndef WALLBOXCHARGER_H
#define WALLBOXCHARGER_H

#define CAN_ENABLE
//#define HOST_DEBUG

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QTimer>
#include <QDebug>
#include <QEventLoop>
#include <QDateTime>
#include <QNetworkInterface>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QSocketNotifier>
#include <QTextStream>
#include <iostream>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#include <QProcess>
#include <QThread>

#ifdef CAN_ENABLE
    #include <QCanBus>
    #include <QtEndian>
#endif

class WallboxCharger : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int evSoc READ GetSoC NOTIFY notify)
    Q_PROPERTY(QString evVoltage READ GetVoltage NOTIFY notify)
    Q_PROPERTY(QString evCurrent READ GetCurrent NOTIFY notify)
    Q_PROPERTY(quint8 evChargeState READ GetChargeState NOTIFY notify)
    Q_PROPERTY(quint8 evPlugState READ GetPlugState NOTIFY notify)
    Q_PROPERTY(QString evChargeTime READ GetElapsedTime NOTIFY notify)
    Q_PROPERTY(QString evDeliveredEnergy READ GetEnergy NOTIFY notify)
    Q_PROPERTY(qint8 evState READ GetState NOTIFY notify)
    Q_PROPERTY(QString evPower READ GetPower NOTIFY notify)
    Q_PROPERTY(quint8 isRemoteStart READ GetRemoteStart NOTIFY notify)
    Q_PROPERTY(quint8 isRemoteStop READ GetRemoteStop NOTIFY notify)
    Q_PROPERTY(QString rfidUUID READ GetRFIDUUID NOTIFY notify)
    Q_PROPERTY(QString macAddress READ GetMACaddress NOTIFY notify)
    Q_PROPERTY(QString ipAddress READ GetIPaddress NOTIFY notify)
    Q_PROPERTY(QString cpID READ GetCPID NOTIFY notify)
    Q_PROPERTY(bool autoChargeVal READ GetAutoCharge NOTIFY notify)
    Q_PROPERTY(bool offlineModeVal READ GetOfflineMode NOTIFY notify)
    Q_PROPERTY(QString qrCodeText READ GetQRText NOTIFY notify)
    Q_PROPERTY(QString adminPasswd READ GetAdminPassword NOTIFY notify)
    Q_PROPERTY(QString ocppServerHost READ GetServerHost NOTIFY notify)
    Q_PROPERTY(QString ocppServerPath READ GetServerPath NOTIFY notify)
    Q_PROPERTY(int ocppServerPort READ GetServerPort NOTIFY notify)

public:
    explicit WallboxCharger(QObject *parent = nullptr);
    ~WallboxCharger();

    int GetSoC() const { return EVSOC; }
    QString GetVoltage() const { return voltage_str; }
    QString GetCurrent() const { return current_str; }
    QString GetPower() const { return power_str; }
    quint8 GetChargeState() const { return EVChargeState; }
    quint8 GetPlugState() const { return EVPlugState; }
    QString GetElapsedTime() const { return timestamp_str; }
    QString GetEnergy() const { return energy_str; }
    qint8 GetState() const { return EV_STATE; }
    quint8 GetRemoteStart() const { return isRemoteStart; }
    quint8 GetRemoteStop() const { return isRemoteStop; }
    QString GetRFIDUUID() const { return RFID_uuid; }
    QString GetMACaddress() const { return MACaddr; }
    QString GetIPaddress() const { return IPaddr; }
    QString GetServerHost() const { return serverHost; }
    int GetServerPort() const { return serverPort; }
    QString GetServerPath() const { return serverPath; }
    bool GetOfflineMode() const { return offlineMode; }
    QString GetCPID() const { return CP_ID; }
    QString GetQRText() const { return qrText; }
    bool GetAutoCharge() const { return autoCharge; }
    QString GetAdminPassword() const { return adminPassword; }
#ifdef CAN_ENABLE
    bool CAN_Init(void);
#endif
    bool openFifo(void);

public slots:
    bool checkNetworkConnection(void);
    void resetRemoteOperations(void);
    bool isOCPPProcessRunning(void);
    bool isRFIDTagSuccess(void);
    void getNetworkInfo(void);
    void jSON_ConfigUpdate(QVariant domain, QVariant port, QVariant path, QVariant cpId, QVariant qrText);
    void jSON_ConfigRead(void);
    bool initializeDatabase(QSqlDatabase &db, const QString &dbPath);
    bool addRFID(const QVariant uid);
    bool searchRFID(const QVariant uid);
    bool deleteRFID(const QVariant uid);
    void trueRFID(void);
    void wrongRFID(void);
    void buzzerOn(void);
    void buzzerOff(void);
signals:
    void notify();
    void notice(QVariant data);

private slots:
#ifdef CAN_ENABLE
    void CANReceive(void);
#endif
    void onDataAvailable();

private:
#ifdef CAN_ENABLE
    QString errorString;
    QCanBusDevice *canDevice;
    QCanBusFrame CANTXhmi;
    QByteArray msgHMIPayload;
#endif
    double EVPresentVoltage;
    double EVPresentCurrent;
    double EVSOC;
    uint8_t EVChargeState;
    uint8_t EVPlugState;
    uint32_t EVElapsedChargeTime;
    double EVDeliveredEnergy;
    int EV_STATE;
    double EVPower;

    QString RFID_uuid;
    QString IPaddr;
    QString MACaddr;

    QString EVElapsedChargeTime_str;
    QString voltage_str, current_str, energy_str, power_str, timestamp_str;

    bool isRemoteStart = false;
    bool isRemoteStop = false;
    QFile fifoFile;
    QSocketNotifier *notifier;

#ifndef HOST_DEBUG
    const QString configJSONFilename = "/root/config.json";
    QString databasePath = "/root/rfid_database.db";
#else
    const QString configJSONFilename = "/home/fdereli/config.json";
    QString databasePath = "/home/fdereli/rfid_database.db";
#endif

    QString serverHost;
    int serverPort;
    QString serverPath;
    bool offlineMode;
    bool autoCharge;
    QString qrText;
    QString adminPassword;
    QString CP_ID;

    QSqlDatabase db;
};

#endif // WALLBOXCHARGER_H
