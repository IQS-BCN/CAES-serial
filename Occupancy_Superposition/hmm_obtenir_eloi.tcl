proc hmm_descarga {domain} {

	global path

	set pathHMM "$path/HMM_Eloy"
	#comprobar si ya existe ela rchivo y si no descargarlo
	set ah [file exists "$path/hmms/${domain}.hmm"]


    if {$ah == 0} {

    	puts "buscando hmm"

		
		if {[file exists "$pathHMM/$domain/$domain.hmm"]} {
			catch {file copy "$pathHMM/$domain/$domain.hmm" "$path/hmms/$domain"}
		}
		if {[file exists "$path/hmms/$domain"]} {
        		catch {exec mv "$path/hmms/$domain" "$path/hmms/$domain.hmm"}
    			}

		
		# catch {read [exec wget -O $path/hmms/$domain.hmm http://pfam.xfam.org/family/$domain/hmm]}
		# catch {read [exec wget -O $path/hmms/$domain.hmm http://pfam-legacy.xfam.org/family/$domain/hmm]}
		# catch {read [exec wget -O $path/hmms/$domain.gz https://www.ebi.ac.uk/interpro/wwwapi//entry/pfam/$domain?annotation=hmm]}
		# catch {exec gunzip -d "$path/hmms/$domain.gz"}
		# if {[file exists "$path/hmms/$domain"]} {
        # 		catch {exec mv "$path/hmms/$domain" "$path/hmms/$domain.hmm"}
    	# 		}
		puts "hmm guardado"

	} else {puts "hmm ${domain} ya guardado"}
}
