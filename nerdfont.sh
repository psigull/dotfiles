#git clone --depth 1 https://github.com/ryanoasis/nerd-fonts

cd nerd-fonts
fontforge -script font-patcher --name 'WiredMono' --mono --complete /usr/share/fonts/TTF/IBMPlexMono-Medium.ttf  --outputdir ~/.local/share/fonts/
fontforge -script font-patcher --name 'WiredPropo' --variable-width-glyphs --complete /usr/share/fonts/TTF/IBMPlexMono-Medium.ttf  --outputdir ~/.local/share/fonts/
fc-cache -rf
cd ../
