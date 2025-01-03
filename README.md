<table style="margin: 0px auto;border: 0;">
  <tr>
    <td><h1>Wallbox Charging Station HMI SW</h1></td>
    <td><img src="https://fevzidereli.com/fd_logo.png" width="50" height="50" /></td>
  </tr>
</table>


**In this repo, the user interface software of a wallbox charging station was developed using the DMT80480T050_36WTC Linux LCD module by DWIN company.**

## Compile & Run

Clone the project

```bash
  git clone https://github.com/fevz10/wallboxHMI.git
```

Go to the project directory

```bash
  cd wallboxHMI
```

Compile the project with qmake & make

```bash
  mkdir build && cd build
  qmake -r ..
  make
```

Run the GUI

```bash
  ./wallboxHMI
```
