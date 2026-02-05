;;指定自定义文件
(setq custom-file (expand-file-name "~/.emacs.d/custom.el"))
(if (file-exists-p custom-file)
    (load custom-file))
;;备份文件
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
;;软件包
(require 'package)
(setq package-archives
      '(("elpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("elpa-devel" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu-devel/")
        ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("nongnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
        ("nongnu-devel" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu-devel/")))
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(setq use-package-verbose t)
(setq use-package-always-ensure t)
(setq use-package-always-demand t)
(setq use-package-compute-statistics t)
(setq use-package-vc-prefer-newest t)
;;字体
(set-face-attribute 'default nil
		    :family "Iosevka"
		    :height 90
		    :weight 'normal
		    :width 'normal)
;;界面
(setq inhibit-startup-screen t)
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(global-display-line-numbers-mode 1)
(add-hook 'dashboard-mode-hook (lambda () (display-line-numbers-mode -1)))
;;主题
(load-theme 'catppuccin :no-confirm)
;;基础设置
(fset 'yes-or-no-p 'y-or-n-p)
(electric-pair-mode t)
(setq echo-keystrokes 0.1)
(setq track-eol t)               ;;光标行尾移动
(setq recentf-max-menu-items 10)
(savehist-mode 1)
(global-visual-line-mode 1)
;;Keybind
(global-set-key (kbd "<f9>") 'compile)
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)
;;时间显示
(display-time-mode 1)
(setq display-time-24hr-format t
      display-time-day-and-date t 
      display-time-use-mail-icon t  
      display-time-interval 10  
      display-time-format "%A %H:%M")
;;dashboard
(use-package dashboard
  :init
  (setq dashboard-startup-banner "~/.emacs.d//elpa/dashboard-20251231.1631/banners/gnu.png"
	dashboard-center-content t
	dashboard-items '((recents . 5)
			  (bookmarks . 5)
			  (agenda . 5))
	dashboard-page-separator "\n"
	dashboard-set-footer nil)
  :config
  (dashboard-setup-startup-hook))
;;dired设置
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)
;;pdf-tools
(pdf-loader-install)
(add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))
;;org-noter
(use-package org-noter
  :load-path "~/notes/"
  )
;;IDO
;(require 'ido)
;(ido-mode t)
;;Enable Vertico
(use-package vertico
 :custom
 (vertico-scroll-margin 0)
 (vertico-count 5)
 (vertico-resize t)
 (vertico-cycle t)
 :init
 (vertico-mode))
(use-package savehist
 :init
 (savehist-mode))
(use-package emacs
 :custom
 (enable-recursive-minibuffers t)
 (read-extended-command-predicate #'command-completion-default-include-p)
 :init
 (setq minibuffer-prompt-properties
       '(read-only t cursor-intangible t face minibuffer-prompt))
 (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode))
(use-package orderless
 :custom
 (completion-styles '(orderless basic))
 (completion-category-defaults nil)
 (completion-category-overrides '((file (styles partial-completion)))))
;;consult
(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("M-s l" . consult-line)
         ("M-s r" . consult-ripgrep)
         ("M-s i" . consult-imenu))
  :custom ((consult-preview-key 'any)
           (consult-narrow-key "<")
           (consult-project-function #'consult--default-project-function)))
(add-hook 'org-mode-hook
 	  (lambda ()
	    (local-unset-key (kbd "M-s l"))
	    (local-set-key (kbd "M-s l") 'org-occur)))
;;Marginalia
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy)))
;;Embark
(use-package embark
 :bind
 (("C-." . embark-act) ;; 执行动作
  ("C-;" . embark-dwim) ;; 智能动作
  ("C-h B" . embark-bindings)) ;; 查看绑定
 :init
 (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode))
;;org-roam
(use-package org-roam
 :custom
 (org-roam-directory "~/notes/") ;; 默认笔记目录
 (org-roam-dailies-directory "~/notes/daily/") ;; 默认日记目录
 :bind (("C-c n f" . org-roam-node-find)
        ("C-c n i" . org-roam-node-insert)
        ("C-c n c" . org-roam-capture)
        ("C-c n l" . org-roam-buffer-toggle)
        ("C-c n u" . org-roam-ui-mode))
 :config
 (require 'org-roam-dailies)
 (org-roam-db-autosync-mode))
;;multiple-cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;;markdown-mode
(use-package markdown-mode
  :mode("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))
(use-package grip-mode
  :hook (markdown-mode . grip-mode)
  :config (setq grip-preview-use-webkit t))
;;company-mode
(use-package company
 :init
 (global-company-mode))
(setq company-backends '(company-files company-keywords company-yasnippet company-dabbrev))  ;; 源优先级
(setq company-idle-delay 0.2)  ;; 延迟0.2s
(setq company-minimum-prefix-length 2)  ;; 最小字符数
(global-set-key (kbd "TAB") 'company-complete)  ;; TAB 触发
(setq company-tooltip-align-annotations t)  ;; 补全列表外观
;;Org-mode
(require 'org-contrib)
(require 'org-protocol)
(setq org-enforce-todo-dependencies t)
(defun org-summary-todo (n-done n-not-done)
      "Switch entry to DONE when all subentries are done, to TODO otherwise."
      (let (org-log-done org-log-states)   ; turn off logging
        (org-todo (if (= n-not-done 0) "DONE" "TODO")))) 
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
