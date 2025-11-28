# OP Flash Tool User Guide

This guide details the process of installing drivers, entering EDL mode, and reading/writing partition data using the OP Flash Tool batch scripts.

-----

## 0\. Prerequisites & Driver Installation

Before starting, ensure you have **ADB Platform Tools** installed and the **Qualcomm HS-USB QDLoader 9008** drivers set up.

### Driver Details

  * **Description:** Qualcomm Incorporated – Other hardware – Qualcomm HS-USB QDLoader 9008
  * **UpdateID:** `bcdb99c1-fd4a-4ded-a97f-5bcf6e57fb58`
  * **CAB File:** [20855130_dae427ffe0a2d6268aa209d782d05ea874aad0dc.cab](https://catalog.s.download.windowsupdate.com/c/msdownload/update/driver/drvs/2016/04/20855130_dae427ffe0a2d6268aa209d782d05ea874aad0dc.cab)  
  * **SHA1:** `2uQn/+Ci1iaKognXgtBeqHSq0Nw=`
  * **SHA256:** `R7UwHc4+FjnBC4Bxs4EifOUjf6h5c/8Cgok9TgPlL+U=`

### How to Install the .cab Driver

> **Note:** These instructions assume the `.cab` file is located in your current user's Downloads folder (`%USERPROFILE%\Downloads`). Adjust the path in the command below if you saved the file elsewhere.

1.  Open Command Prompt as **Administrator**.
2.  Run the following DISM command:

<!-- end list -->

```cmd
dism /online /add-package /packagepath:"%USERPROFILE%\Downloads\20855130_dae427ffe0a2d6268aa209d782d05ea874aad0dc.cab"
```
### Install platform-tools
```powershell
winget install Google.PlatformTools
```

-----

## 0.1\. Prepare OPLUS Resources (Chimera)

If you are working with Oplus devices (OnePlus, Oppo, Realme) and have the Chimera_OPLUS_files.zip archive, you must extract the specialized programmers/auth files before starting.
* Locate the Archive: Ensure Chimera_OPLUS_files.zip is saved on your computer.
* Extract: Unzip the contents to a known location.

## 1\. Enter Firehose Mode

Initialize the tool and set up the programmer paths.

1.  Navigate to the current directory of the tool.
2.  Run the initialization script:
    ```cmd
    .\1.Enter_firehose_mode.bat
    ```
3.  Follow the on-screen prompts to input paths for:
      * **Device Programmer**
      * **Digest**
      * **Signature files**

-----

## 2\. Connect & Enter EDL Mode

Connect your device to the computer. Use a **USB 2.0** port if available for better stability.

1.  Connect the phone via USB.
2.  Open a terminal/command prompt and run:
    ```cmd
    adb reboot edl
    ```
    *(The device should now be in 9008/EDL mode).*
    The Device manager should show the following (Port # could be different:
    <img width="472" height="67" alt="image" src="https://github.com/user-attachments/assets/266444c8-f6f3-4003-8aea-fd13d4f076a5" />


-----

## 3\. Read Back Data (Dump)

Use this step to dump partition data based on a provided XML map.

1.  Run the read script:
    ```cmd
    .\2.Read_by_xml.bat
    ```
2. **Oplus Mode:** Type `y`.

3.  **Input XML Path:** Drag and drop your `*.xml` file into the window.
4.  **Confirm:** Type `y` and press Enter.
> **Output:** Files are saved to a folder named `readback_xml_[timestamp]`.

-----

## 4\. Write Data (Flash)

Use this step to flash images to the device.

1.  Run the write script:
    ```cmd
    .\3.Write_by_xml.bat
    ```
2.  **Oplus Mode:** Type `y`.
3.  **Input XML Path:** Drag and drop your `*.xml` file into the window.
4.  **Confirm:** Type `y` and press Enter.


> **Note:** The script automatically detects the image directory based on the location of the XML file provided.

-----

## 5\. Reboot Device

Once operations are complete, restart the device.

1.  Run the reboot script:
    ```cmd
    .\4.Reboot.bat
    ```

-----

## Extra Utilities
### Test Read/Write Mode

To verify communication and configuration without performing a full read or write operation:

```cmd
.\Test_rw_mode.bat
```
