;; doxygen skeleton

(define-skeleton c-doxygen-block
  "put a simple doxygen block"
  > "/***" '(backward-char) \n
  '(forward-char) " " _ \n
  > "*/" \n)

(define-skeleton c-doxygen-doc-this-file
  "insert the block for this file"
  > "/**\n"
  " * @file " (buffer-name) "\n"
  " * @author Jianer Cong\n"
  " * @brief " _ "\n"
  > "*/" )

(defun c-doxygen-block-ready-to-Mj ()
  "insert doc block and set prefix"
  (interactive)
  (c-doxygen-block)
  (set-fill-prefix)
  (insert "@brief ")
  )
