<div style="text-align: center;">
  <img src="https://fevzidereli.com/fd_logo.png" width="200" height="200" />
</div>

# Wallbox Charging Station HMI SW

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
