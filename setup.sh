#!/bin/bash

GREEN='\033[32m'
RED='\033[31m'
YELLOW='\033[33m'
RESET='\033[0m'

check_command() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}$1 is not installed.${RESET}"
        return 1
    else
        echo -e "${GREEN}$1 is already installed.${RESET}"
        return 0
    fi
}

install_apt() {
    echo -e "${YELLOW}Installing $1 using apt...${RESET}"
    sudo apt-get update
    sudo apt-get install -y "$1"
}

install_git_clone() {
    echo -e "${YELLOW}Cloning $2 from GitHub...${RESET}"
    git clone "$1" "$2"
}

install_go() {
    echo -e "${YELLOW}Installing $1 using go install...${RESET}"
    go install "$1"
}

install_pip() {
    echo -e "${YELLOW}Installing $1 using pip...${RESET}"
    pip install "$1"
}

apt_tools=("figlet" "lolcat" "curl" "jq" "xdotool")

for tool in "${apt_tools[@]}"; do
    check_command "$tool"
    if [ $? -ne 0 ]; then
        install_apt "$tool"
    fi
done

declare -A go_tools=(
    ["subfinder"]="github.com/projectdiscovery/subfinder/v2/cmd/subfinder"
    ["assetfinder"]="github.com/tomnomnom/assetfinder"
    ["httpx"]="github.com/projectdiscovery/httpx/cmd/httpx"
    ["anew"]="github.com/tomnomnom/anew"
    ["waybackurls"]="github.com/tomnomnom/waybackurls"
    ["hakrawler"]="github.com/hakluke/hakrawler@latest"
    ["katana"]="github.com/projectdiscovery/katana/cmd/katana"
    ["gospider"]="github.com/jaeles-project/gospider@latest"
    ["naabu"]="github.com/projectdiscovery/naabu/v2/cmd/naabu"
    ["ffuf"]="github.com/ffuf/ffuf/v2@latest"
)

for tool in "${!go_tools[@]}"; do
    check_command "$tool"
    if [ $? -ne 0 ]; then
        install_go "${go_tools[$tool]}"
    fi
done

declare -A git_tools=(
    ["Sublist3r"]="https://github.com/aboul3la/Sublist3r.git"
    ["ParamSpider"]="https://github.com/devanshbatham/paramspider.git"
    ["gf"]="https://github.com/tomnomnom/gf.git"
)

for tool in "${!git_tools[@]}"; do
    if [ ! -d "$HOME/tools/$tool" ]; then
        install_git_clone "${git_tools[$tool]}" "$HOME/tools/$tool"
    else
        echo -e "${GREEN}$tool is already cloned in $HOME/tools/$tool.${RESET}"
    fi
done

if [ ! -d "$HOME/.gf" ]; then
    echo -e "${YELLOW}Setting up gf patterns...${RESET}"
    mkdir -p "$HOME/.gf"
    cp -r "$HOME/tools/gf/examples/"* "$HOME/.gf/"
    echo -e "${GREEN}gf patterns have been set up.${RESET}"
else
    echo -e "${GREEN}gf patterns are already set up.${RESET}"
fi


if [ ! -d "$HOME/tools/Gf-Patterns" ]; then
    echo -e "${YELLOW}Cloning Gf-Patterns...${RESET}"
    git clone https://github.com/1ndianl33t/Gf-Patterns "$HOME/tools/Gf-Patterns"
    cp "$HOME/tools/Gf-Patterns/"*.json "$HOME/.gf/"
    echo -e "${GREEN}Gf-Patterns have been installed in ~/.gf.${RESET}"
else
    echo -e "${GREEN}Gf-Patterns is already cloned in $HOME/tools/Gf-Patterns.${RESET}"
fi


check_command "knockpy"
if [ $? -ne 0 ]; then
    install_pip "git+https://github.com/guelfoweb/knock.git"
fi

echo -e "${YELLOW}Downloading and setting up pattrans...${RESET}"
if [ ! -d "$HOME/tools/pattrans" ]; then
    git clone https://github.com/someone/pattrans.git "$HOME/tools/pattrans"
    echo -e "${GREEN}pattrans has been cloned to $HOME/tools/pattrans.${RESET}"
else
    echo -e "${GREEN}pattrans is already cloned in $HOME/tools/pattrans.${RESET}"
fi

echo -e "${YELLOW}Setting up kidrecon.sh...${RESET}"

if [ ! -f "./kidrecon.sh" ]; then
    echo -e "${RED}kidrecon.sh not found in the current directory.${RESET}"
    exit 1
fi

chmod +x kidrecon.sh
echo -e "${GREEN}kidrecon.sh is now executable.${RESET}"

sudo mv ./kidrecon.sh /usr/local/bin/kidrecon
sudo ln -sf /usr/local/bin/kidrecon /usr/local/bin/kr

echo -e "${GREEN}You can now run the tool by typing 'kr' or 'kidrecon' from anywhere.${RESET}"

echo -e "${GREEN}All tools are installed and kidrecon is ready to use!${RESET}"

echo -e "${YELLOW}Note: Please check Sublist3r, ParamSpider, and pattrans manually. Go into their directories and install any necessary dependencies to avoid issues.${RESET}"

echo -e "${YELLOW}Copying Go binaries to /usr/bin for global access...${RESET}"
sudo cp ~/go/bin/* /usr/bin/

echo -e "${GREEN}Go binaries are now accessible from anywhere!${RESET}"

echo -e "${GREEN}You can now type 'kidrecon' or 'kr' to start the tool.${RESET}"
