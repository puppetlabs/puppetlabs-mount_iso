# mount_iso

## Table of Contents

1. [Overview](#overview)

2. [Module Description - Mount ISO Images on Windows 2012+](#module-description)

3. [Setup - The basics of getting started with mount_iso](#setup)

    * [What mount_iso affects](#what-mount_iso-affects)

4. [Usage - Configuration options and additional functionality](#usage)

5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)

6. [Limitations - OS compatibility, etc.](#limitations)

## Overview

Ability to automatically mount disk images from within a defined type in order to install certain products on Windows

## Module Description

Requires PowerShell which is installed by default for any newer versions of Windows

## Setup

### What mount_iso affects

* Mounted Disk Images already in place, will move if the current mounted Image is not on the correct drive

## Usage

### To mount the SQLServer.iso on drive letter 'H'

``` puppet
mount_iso { 'C:\MyStagingDir\SQLServer.iso':
  drive_letter => 'H',
}
```

### Beginning with mount_iso

## Reference

### Defined Types

#### mount_iso

* `source`: The location of the ISO or image that you would like mounted: Defaults to title

* `drive_letter`: The desired drive letter you want the image to mounted against

## Limitations

* Only works on Windows 2012+.

* If the drive is already occupied by some other volume it will fail to mount the image in that location but will allow it to be mounted on the first available drive letter.

