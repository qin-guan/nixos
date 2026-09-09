update:
	git add -A
	git commit -m "chore: update"
	git push
	sudo nixos-rebuild switch
