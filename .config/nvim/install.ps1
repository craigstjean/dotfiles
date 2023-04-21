git clone https://github.com/wbthomason/packer.nvim "$env:LOCALAPPDATA\nvim-data\site\pack\packer\start\packer.nvim"

pip install cmake-language-server
npm install -g vscode-langservers-extracted
go install golang.org/x/tools/gopls@latest
npm install -g typescript typescript-language-server
npm install -g @volar/vue-language-server

scoop install lua-language-server
choco install rebar3 -y

