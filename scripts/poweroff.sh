#!/usr/bin/env bash

# Author: Dmitri Popov, dmpop@linux.com

#######################################################################
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#######################################################################

WORKING_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CONFIG="${WORKING_DIR}/config.cfg"
dos2unix "$CONFIG"
source "$CONFIG"

# Configuration
FILE_OLED_OLD="${WORKING_DIR}/tmp/oled_old.txt"
FILE_LOG="${WORKING_DIR}/tmp/little-backup-box.log"
FSCK_LOG="${WORKING_DIR}/tmp/fsck.log"

# Load LCD library
. "${WORKING_DIR}/lib-lcd.sh"

#Arguments
ACTION="${1}"
FORCE="${2}"

echo "ACTION=$ACTION FORCE=$FORCE"

# Power off
if [ "$POWER_OFF" = "true" ] || [ "${FORCE}" = "force" ]; then
    # umount
    umount "${STORAGE_MOUNT_POINT}"
    umount "${SOURCE_MOUNT_POINT}"

    # If display support is enabled, notify that the backup is complete
    if [ "$DISP" = "true" ]; then

        if [ "${FORCE}" = "force" ]; then
            if [ "${ACTION}" = "poweroff" ]; then
                lcd_message "+Power off." "+Do not unplug" "+while the ACT" "+LED is on. Bye!"
            elif [ "${ACTION}" = "reboot" ]; then
                lcd_message "+Reboot." "+Do not unplug" "+I'm back soon!" "+Bye!"
            fi
        else
            lcd_message "+Backup complete." "+Do not unplug" "+while the ACT" "+LED is on. Bye!"
        fi
    fi

    echo "" >"${FILE_OLED_OLD}"
    rm "${FILE_LOG}"
    rm "${FSCK_LOG}"

    if [ "${ACTION}" = "poweroff" ]; then
        poweroff
    elif [ "${ACTION}" = "reboot" ]; then
        reboot
    fi

else
    # If display support is enabled, notify that the backup is complete
    if [ "$DISP" = "true" ]; then
        lcd_message "+Backup complete." "-Do not unplug!" "+Power down via" "+web UI"
    fi
fi
