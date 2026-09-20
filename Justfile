update:
	nix flake update
	git add -A
	git commit -m "chore: update" || true
	git push
	sudo nixos-rebuild switch

update-boot:
	nix flake update
	git add -A
	git commit -m "chore: update" || true
	git push
	sudo nixos-rebuild boot
