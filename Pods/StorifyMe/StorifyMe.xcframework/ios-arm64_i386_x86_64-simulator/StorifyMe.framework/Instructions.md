#  Instructions

## How do release a new version of the library?

Go to **StorifyMe** folder, update the new VERSION in release.sh, and run **bash release.sh** script.

This script will generate release libraries, zip them and upload them to StorifyMe S3 bucket to be served from the CDN alognside StorifyMe.podspec.json file.

NOTE: When releasing a new version, please go ahead and update **VERSION** in release.sh.
 
If you do not see the StorifyMe Cocoapod, please run:

```bash
pod repo update
pod search StorifyMe
```