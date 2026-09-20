default: build

build:
	bash setup.sh

clean:
	rm -rfv dotfile_bk_* || true
	rm -rfv ~/.config/nvim || true
	rm -rfv ~/.config/fish || true
	rm -rfv ~/.config/vim || true
	rm -rfv vim/.vim/plugged || true
	rm -rfv vim/.vim/undodir || true
	rm -rfv ~/.vimrc || true
	rm -rfv ~/.vimrc.bk || true
	rm -rfv ~/.vim || true
