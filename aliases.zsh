# Shortcuts
alias c="clear"
alias reloadshell="omz reload"
alias phpstorm='open -a /Applications/PhpStorm.app "`pwd`"'
alias timestamp="date +%s"
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"
alias projects="cd $HOME/Code"
alias sites="cd $HOME/Herd"

# Laravel
alias a="herd php artisan"
alias fresh="herd php artisan migrate:fresh --seed"
alias tinker="herd php artisan tinker"
alias seed="herd php artisan db:seed"
alias serve="herd php artisan serve"

# PHP
alias cfresh="rm -rf vendor/ composer.lock && composer i"
alias composer="herd composer"
alias php="herd php"
alias test="pest --no-coverage"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias watch="npm run dev"
