update:
	git add -A
	git commit -m "chore: update" || true
	git push
	nix flake update && sudo nixos-rebuild switch

update-boot:
	git add -A
	git commit -m "chore: update" || true
	git push
	nix flare update && sudo nixos-rebuild boot
