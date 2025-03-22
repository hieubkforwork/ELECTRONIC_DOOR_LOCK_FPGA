# CO3091: Project of Logic Design 
# Electronic Lock

## 5.1 Introduction
Electronic locks are becoming increasingly popular in daily life. They are commonly used in offices and homes. This type of lock uses a password for access instead of a physical key. If an intruder enters the wrong password multiple times, the system will increase the waiting time for the next password attempt and send a notification to the homeowner's mobile device.

## 5.2 Requirements
Use knowledge from HDL Logic Design and related subjects to build a simple electronic lock system on the FPGA development board Arty-Z7 or an equivalent platform.

### System Design:
- Use switches to enter input values into the system.
- Use single LEDs and 7-segment LEDs to display system output information.
- Use buttons to perform computational tasks and display results.

### System Functions:
- Use one button to simulate locking/unlocking the door.
- Use buttons or switches to enter the password.
- The system uses four 7-segment LEDs and four switches to simulate the password entry process.
  - The password length is four characters (0-9 and A-F).
  - The password is entered character by character, with the most recent input displayed on the rightmost 7-segment LED.
  - Previously entered characters shift left by one position automatically.
  - After completing the input, the system will verify whether the password is correct or incorrect.
  - If correct, the system proceeds to the next step.
  - If incorrect, the system requires the user to re-enter the password.
  - The system must support setting an initial default password and allow password changes.
- After entering the correct password, the system notifies the user to open the door (press the button).
  - If the door is not opened within 10 seconds, the system automatically locks the door and requires password re-entry.
- Once the user opens the door, if they do not close it manually, the system will issue a warning after 30 seconds.
  - The user has the option to stop this warning.
- After the user opens and then closes the door, the system locks the door again after 10 seconds.
- If the user enters the wrong password, they are allowed up to 3 attempts.
  - After 3 failed attempts, the system will issue a security alert, suspecting unauthorized access.
  - The user will be allowed to retry only after 1 minute, with an increasing delay if incorrect entries continue.

## 5.3 Suggested Additional Features
- Design a door lock simulation model using stepper motors, buzzers, speakers, etc., interfacing via GPIO pins.
- Display information on a screen using VGA communication.
- Display information on a 16x2 LCD screen.
- Students may propose additional features.


## MEMBER

|    NAME       |
| -------- |
|DƯƠNG MINH HIẾU|
|NGUYỄN KHẮC DUY|
|TRỊNH THỊ MỸ LỆ|
|NGUYỄN TUẤN ANH|


## HARDWARE
Board: ARTY Z7-20

## SOFTWARE
Vivado 2022.2

