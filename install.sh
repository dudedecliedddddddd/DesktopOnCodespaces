git clone https://github.com/quantumnova87/DesktopOnCodespaces
cd DesktopOnCodespaces
pip install textual
sleep 2
python3 installer.py
docker build -t desktoponcodespaces . --no-cache
cd ..

sudo apt update
sudo apt install -y jq

mkdir Save
cp -r DesktopOnCodespaces/root/config/* Save

json_file="DesktopOnCodespaces/options.json"
if jq ".enablekvm" "$json_file" | grep -q true; then
    docker run -d --name=DesktopOnCodespaces -e PUID=1000 -e PGID=1000 --device=/dev/kvm --security-opt seccomp=unconfined -e TZ=Etc/UTC -e SUBFOLDER=/ -e TITLE=GamingOnCodespaces -p 3000:3000 --shm-size="2gb" -v $(pwd)/Save:/config --restart unless-stopped desktoponcodespaces
else
    docker run -d --name=DesktopOnCodespaces -e PUID=1000 -e PGID=1000 --security-opt seccomp=unconfined -e TZ=Etc/UTC -e SUBFOLDER=/ -e TITLE=GamingOnCodespaces -p 3000:3000 --shm-size="2gb" -v $(pwd)/Save:/config --restart unless-stopped desktoponcodespaces
fi
clear
echo "**** Fixing broken dependencies ****"
apt update
apt --fix-broken install -y

echo "**** Installing OpenJDK 17 ****"
apt install -y openjdk-17-jdk wget unzip

echo "**** Downloading TLauncher ****"
wget -O /tmp/TLauncher.jar https://repo.tlauncher.org/update/lch/starter-core-1.11-v10.jar
mkdir -p /opt/tlauncher
mv /tmp/TLauncher.jar /opt/tlauncher/

cat > /usr/share/applications/tlauncher.desktop <<EOL
[Desktop Entry]
Name=TLauncher
Comment=Minecraft launcher
Exec=java -jar /opt/tlauncher/TLauncher.jar
Icon=/opt/tlauncher/TLauncher_icon.png
Terminal=false
Type=Application
Categories=Game;
EOL

wget -O /opt/tlauncher/TLauncher_icon.png https://cdn.icon-icons.com/icons2/2699/PNG/512/minecraft_logo_icon_168974.png

chmod +x /usr/share/applications/tlauncher.desktop

echo "**** TLauncher installation completed ****"
