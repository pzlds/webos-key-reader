#!/bin/bash -e

WORKDIR="/tmp/webos-key-reader"

>&2 echo "[*] Creating work directory (${WORKDIR})..."
mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

if [ ! -f "gdb" ]; then
>&2 echo "[*] Obtaining GDB..."
curl -sS -L -o gdb "https://github.com/marcinguy/arm-gdb-static/raw/master/gdbstatic"
chmod +x gdb
fi

>&2 echo -n "[*] Searching for tvservice process..."
# `pidof` does not work here for whatever reason.
TVSERVICE_PID="$(ps --no-heading -o pid= -C tvservice | xargs | cut -f1)"
>&2 echo " found. (${TVSERVICE_PID})"

>&2 echo "[*] Attaching to the process (this may take a few seconds and print a few warnings)..."
cat << 'EOF' > dump.gdb
# The function export indicates that PVR_DEBUG_RetrieveDvrKey
# requires a uint8_t * and a uint32_t * as parameters, which are apparently
# the target buffer and a pointer to its size in bits (as 16 doesn't work, but 128 does).
# Since we are dumping an AES-128 key, let's create a 16 byte buffer and set the
# size accordingly.
printf "[*] Setting up buffers...\n"
set $key_size = 16
set $target_buf = (uint8_t *) malloc($key_size)
set $target_len_buf = (uint32_t *) malloc(sizeof(uint32_t))
set *$target_len_buf = $key_size * 8

# Call the PVR_DEBUG_RetrieveDvrKey function.
printf "[*] Dumping the key...\n"
call PVR_DEBUG_RetrieveDvrKey($target_buf, $target_len_buf)

# Fetch the dumped key from the memory location.
printf "[!] DVR key:\n"
x/16bx $target_buf

# Free the buffers again.
printf "[*] Freeing buffers...\n"
call (void) free($target_buf)
call (void) free($target_len_buf)
EOF

./gdb --batch -x dump.gdb -p "${TVSERVICE_PID}"

>&2 echo "[*] Done!"
