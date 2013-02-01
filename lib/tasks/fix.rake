namespace :fix do
	desc "Read the original XML files to get the number of pages in each document and cache that value."
	task :add_total_pages => :environment do
		documents = Document.all
		documents.each_with_index { |doc, index|
			if doc.total_pages.blank?
				begin
					num_pages = doc.get_num_pages()
				rescue Exception => e
					puts "#{doc.uri}: #{e.to_s}"
				end

				doc.update_attributes!({ total_pages: num_pages })
			end
			print "\n[#{index}]" if index % 100 == 0
			print '.'
		}
	end

	desc "Find usages of null documents in the database"
	task :analyze_null_documents => :environment do
		documents = Document.find_all_by_uri(nil)
		documents.each { |doc|
			du = DocumentUser.find_all_by_document_id(doc.id)
			lines = Line.find_all_by_document_id(doc.id)
			pr = PageReport.find_all_by_document_id(doc.id)
			puts "#{doc.id}: usage: #{du.length} #{lines.length} #{pr.length}"
		}
	end
end