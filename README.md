# Capstone Project BEKUPP CREATE 2025

# Pengembang dan Tugasnya (Menyusul): 
	- Anggi
	- Esa
	- Andi
    - Suryani

## Buat branch baru
git branch namaKalian

## Cara push: 
git checkout -b Namakalian

Contoh
git checkout -b anggii

## Tidak boleh push ke main, Haram hukumnya :(

## Kalo ngepush itu hanya boleh ke branch nama kalian, contoh :
	- Check status branch
		git status
		
	- ika ada need to commit dan untracked file
		git add .
		git commit -am "pesan"
		git push origin Namakalian

	- Jika ada need to commit
		git commit -am "pesan"
		git push origin Namakalian

		
  ## Cara Pull, dan hanya boleh pull branch stagging
	- Buat ngecek apakah ada yang perlu dicommit atau gak
		git status
	
	- Jika nothing to commit, clean
		git pull origin stagging
	
	- Jika ada need to commit
		git commit -am "update fitur vendor"
		git pull origin stagging
