
(keymapp nxml-mode-map)               ;t

;; (define-key nxml-mode-map (kbd "\C-c f") 'mp-fig) ;mp-fig
  (when (boundp 'nxml-mode-abbrev-table)
    (clear-abbrev-table nxml-mode-abbrev-table)) ;nil

  (define-abbrev-table 'nxml-mode-abbrev-table
    '(
      ("bl" "﻿<?xml version=\"1.0\" encoding=\"utf-8\"?>")
      ))
