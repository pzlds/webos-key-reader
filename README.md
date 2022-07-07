# webOS Key Reader

This is a tool for webOS TVs (and compatibles?) that reads the DVR encryption key from memory.

## Usage

1. Root your TV using [RootMyTV](https://rootmy.tv/).
2. Connect to the TV using SSH as `root`.
3. Download and run the script like this:

   ```
   curl -L "https://raw.githubusercontent.com/pzlds/webos-key-reader/master/dump.sh" | bash -
   ```

4. Wait until the keys are printed.

## Compatibility

Devices that are not listed have not been tested yet.
Issues or PRs with information about other devices are welcome.

| Model Number | Software Version | webOS Version | DVR Key            |
|--------------|------------------|---------------|--------------------|
| UJ6309       | 06.00.20         | 3.9.0         | :heavy_check_mark: |

## Disclaimer

This tool is intended to help with key retrieval for the purpose of compressing
or repairing recordings. Do not use it for piracy, or any other illegal purpose.

This tool is provided without any kind of warranty. Do not expect any support,
updates, or bugfixes. However, if there is some issue or missing feature,
feel free to open an issue and I may choose to look into it.

To my understanding, `PVR_DEBUG_RetrieveDvrKey` is an API due to being exported
from the ELF, including the function name and parameter information. No other
information has been used for creating this project.
