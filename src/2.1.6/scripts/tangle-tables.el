(with-current-buffer (find-file-noselect "tables.org")
  (org-element-map (org-element-parse-buffer) 'table
    (lambda (table)
      (let ((case-fold-search t)
	    (name (org-element-property :name table)))
	(if (search-forward-regexp (concat "#\\+name: +" name) nil t)
	    (progn
	      (next-line)
	      (org-table-export (format ".build/%s.csv" name)
				"orgtbl-to-csv")))))))
