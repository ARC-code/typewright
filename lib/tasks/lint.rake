namespace :lint do

	desc "Run JSLint on all js files"
	task :all do
		ext = '.js'
		skip_ext = '-min.js'
		Dir.foreach("#{Rails.root}/public/javascripts") { |f|
			if f.index(ext) == f.length - ext.length && f.index(skip_ext) != f.length - skip_ext.length
				if f != 'prototype.js' && f != 'controls.js' && f != 'effects.js' && f != 'dragdrop.js' && f != 'rails.js' && f != 'diff_match_patch_uncompressed.js'
					lint_one(f)
				end
			end
		}
	end

	desc "Run JSLint on one js file"
	task :file do
		name = ENV['file']
		if name == nil
			puts "Usage: rake file=xxxx jslint:all (file should not contain the full path or .js)"
		else
			lint_one(name+'.js')
		end
	end

	def lint_one(fname)
		full_path = "#{Rails.root}/public/javascripts/#{fname}"
		puts "Linting #{fname} (#{full_path})..."
		system("java -jar #{Rails.root}/lib/tasks/rhino1_7R2_js.jar #{Rails.root}/lib/tasks/fulljslint.js #{full_path}")
	end
end
