;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Craig St. Jean"
      user-mail-address "craigstjean@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

(setq doom-font (font-spec :family "Source Code Pro" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq beacon-blink-when-window-scrolls t
      beacon-blink-when-window-changes t
      beacon-blink-when-point-moves t
      beacon-push-mark 10)
(beacon-mode 1)

(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(after! (evil copilot)
  (add-to-list 'copilot-indentation-alist
               '(cpp-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(javascript-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(js-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(js2-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(go-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(org-mode 2))
  (add-to-list 'copilot-indentation-alist
               '(elixir-mode 2))
  (add-to-list 'copilot-indentation-alist
               '(web-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(css-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(sass-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(ssass-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(vue-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(mermaid-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(typescript-mode 4))
  (add-to-list 'copilot-indentation-alist
               '(emacs-lisp-mode 2)))

(after! projectile
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories ".git")
  (add-to-list 'projectile-globally-ignored-directories ".idea")
  (add-to-list 'projectile-globally-ignored-directories ".vscode"))

;; (add-hook 'vue-mode-hook #'lsp!)
;; (use-package! tree-sitter
;;   :config
;;   (require 'tree-sitter-langs)
;;   (global-tree-sitter-mode)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(add-hook 'elixir-mode-hook
          (lambda ()
            (setq-local indent-tabs-mode nil)
            (setq-local tab-width 2)
            (setq-local evil-shift-width 2)))

(use-package! lsp-volar)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (python . t)
   (emacs-lisp . t)
   (js . t)
   (typescript . t)
   (css . t)
   (sass . t)
   (scss . t)
   (mermaid . t)
   (plantuml . t)
   (sql . t)
   (go . t)
   (java . t)
   (ruby . t)
   (rust . t)
   (haskell . t)
   (elixir . t)
   (lisp . t)
   (http . t)
   (awk . t)
   (latex . t)))

(setq display-line-numbers-type 'relative)

