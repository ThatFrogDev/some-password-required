arch = $(uname -i)

if [[ $OSTYPE == "linux-gnu" ]]; then
    if [[ $arch == armv* ]]; then
        echo "Sorry, ARM64 systems are not supported at the moment."
    elif [[ $arch == x86_64* ]]; then
        # Planned support for GNU/Linux x86_64 architectures in the future
        # echo "Running program..."
        echo "Sorry, we only support Windows right now"
    else
        echo "Sorry, your system is not supported. You're most likely running 32-bit or some other obscure architecture."
    fi
elif [[ $OSTYPE == "darwin"* ]]; then
    if [[ $arch == armv* ]]; then
        echo "Sorry, ARM64 systems are not supported at the moment."
    elif [[ $arch == x86_64* ]]; then
        # Planned support for MacOS Intel x86_64 processors in the future
        # echo "Running program..."
    else
        echo "Sorry, your system is not supported. You're most likely running 32-bit or some other obscure architecture."
    fi
elif [[ $OSTYPE == "win"* || uname -s == "windows"* ]]; then
    echo "How did you end up here? Please run the batch script, it's better for your own sanity."
else
    echo "Sorry, your system is not supported. You're probably running something like FreeBSD or some compatibility layer. Use Windows, Mac or Linux."
fi