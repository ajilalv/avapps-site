;; Ajilal Vijayan
;; This lisp can be used to update the registry to load the Drawing Purge app.
;; This lisp will add the below registry value for demand load the app
;; HKEY_CURRENT_USER\Software\Autodesk\AutoCAD\R20.1\ACAD-F001:409\Applications\Dwg-Purge

(vl-load-com)
(defun c:LoadDwgPurge ( / path acadver filepath)
(setq path (strcat (substr (getvar "ROAMABLEROOTPREFIX") 1( + 8(vl-string-search "Autodesk"(getvar "ROAMABLEROOTPREFIX")))) "\\ApplicationPlugins\\AVVADwgPurge.bundle\\Contents\\Windows\\"))
(setq acadver (atof (getvar "acadver")))
(setq filepath
	(cond
		(( = acadver 18.2) "2012" )
		(( = acadver 19.0) "2013-2014" )
		(( = acadver 19.1) "2013-2014" )
		(( = acadver 20.0) "2015" )
		(( = acadver 20.1) "2016-2017" )
		(( = acadver 21.0) "2016-2017" )
		(( >= acadver 22.0) "2018-2019" )
	)
)
(if (vl-file-directory-p path)
	(progn
		(NetDemandLoad "Dwg-Purge" 
			   "This plug-in helps to Purge either the Current drawing or Purge multiple drawings without opening the file" 
			   (strcat path filepath "\\AVVADrawingPurge08-" filepath ".dll")
			   '("DWG-PURGE" "DWG-PURGE-BATCH")
		)
		(princ "Registry Updated, Restart AutoCAD")
	)
	(princ  (strcat "\nDrawing Purge app not found at " path))
);if
);defun

(princ "\nrun the command by calling 'LoadDwgPurge'")


;; Thanks to gile [http://www.theswamp.org]
;;http://www.theswamp.org/index.php?PHPSESSID=d781df0c75957013b57ff97939676efd&topic=31173.msg367509#msg367509

;;; NetDemandLoad
;;; Register a DLL for load on command calling
;;;
;;; Arguments
;;; key : the application key (string)
;;; descr : a description (string)
;;; filename : the dll complete filename (string)
;;; commands : the list of command names (list)
;;;
;;; Example: (NetDemandLoad "MyApp2" "Loads my application" "C:\\gile\\NET applications\\MyApp2.dll" '("CMD1" "CMD2"))

(defun NetDemandLoad (key descr filename commands / regpath)
  (vl-load-com)
  (mapcar
    '(lambda (k v)
       (vl-registry-write
         (setq regpath (strcat "HKEY_CURRENT_USER\\"
                         (vlax-product-key)
                         "\\Applications\\"
                         key
                 )
         )
         k
         v
       )
     )
    '("DESCRIPTION" "LOADCTRLS" "LOADER" "MANAGED")
    (list descr 12 filename 1)
  )
  (foreach c commands
    (vl-registry-write (strcat regpath "\\Commands") c c)
  )
)

(princ)


