namespace :membership_activation do

    # To run this rake task, make sure the necessary SFTP credentials are in .env
    # foreman run rake membership_activation:import_access_code

    desc "Import live access codes into the database"
    task :import_access_code => :environment do
      
        require 'roo'
        
        defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
        defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.schema_search_path = ENV['DB_SCHEMA']
        
        if defined?(Rails) && (Rails.env == 'development')
          Rails.logger = Logger.new(STDOUT)
        end

        Rails.logger.info "Beginning ENT_2471_book file transfer"
        Rails.logger.info "Host:  #{ENV['ENT_SFTP_HOST']}"
        Rails.logger.info "File path: #{ENV['ENT_ACCESS_CODE_BOOK_DATA_FILEPATH']}"

        begin
            File.delete("./tmp/ENT_2471_book.xlsx") if File.exists?("./tmp/ENT_2471_book.xlsx")
            sftp = Net::SFTP.start(
                                            ENV['ENT_SFTP_HOST'],
                                            ENV['ENT_SFTP_USER'],
                                            {
                                                password: ENV['ENT_SFTP_PASSWORD'],
                                                port: ENV['ENT_SFTP_PORT']
                                            }
                                        )
            sftp.download!(ENV['ENT_ACCESS_CODE_BOOK_DATA_FILEPATH'], "./tmp/ENT_2471_book.xlsx")

            file = Roo::Spreadsheet.open('./tmp/ENT_2471_book.xlsx')

        rescue => exception
            Rails.logger.info "Failed to open ENT_2471_book file: #{exception.message}"
        else
            begin
                Rails.logger.info "ENT_2471_book File transfer complete, beginning import"

                total_count = 0
                new_count = 0
                existing_count = 0

                sheet = file.sheet(0)
                sheet.each(id: 'ACTVTN_CD') do |hash|

                  if hash[:id] != 'ACTVTN_CD'

                    access_code = hash[:id].to_s

                    if access_code.include? "."
                      access_code = access_code.split('.')[0]
                    end

                    # Check to see if the this access code already exists in our database
                    code = BookCode.where(code: access_code).first
                    if code
                        existing_count += 1
                        
                        Rails.logger.info "Existed book code: " + access_code
                        
                    else
                        new_count += 1

                        params = {
                            code: access_code,
                            shopify_order_id: 0,
                            shopify_product_id: 0,
                            shopify_line_item_id: 0
                        }

                        code = BookCode.create params

                        Rails.logger.info "Imported book code: " + access_code

                    end

                    total_count += 1

                  end

                end

            rescue => exception
                Rails.logger.info "Failed to import ENT_2471_book file: #{exception.message}"
            else
                Rails.logger.info "Import ENT_2471_book completed successfully"
                Rails.logger.info "#{total_count} total records in file"
                Rails.logger.info "#{new_count} new records imported"
                Rails.logger.info "#{existing_count} existing records updated"
            end
        end

        Rails.logger.info "Beginning ENT_2471_digital file transfer"
        Rails.logger.info "Host:  #{ENV['ENT_SFTP_HOST']}"
        Rails.logger.info "File path: #{ENV['ENT_ACCESS_CODE_DIGITAL_DATA_FILEPATH']}"
        
        begin
            File.delete("./tmp/ENT_2471_digital.xlsx") if File.exists?("./tmp/ENT_2471_digital.xlsx")
            sftp = Net::SFTP.start(
                                            ENV['ENT_SFTP_HOST'],
                                            ENV['ENT_SFTP_USER'],
                                            {
                                                password: ENV['ENT_SFTP_PASSWORD'],
                                                port: ENV['ENT_SFTP_PORT']
                                            }
                                        )
            sftp.download!(ENV['ENT_ACCESS_CODE_DIGITAL_DATA_FILEPATH'], "./tmp/ENT_2471_digital.xlsx")

            file = Roo::Spreadsheet.open('./tmp/ENT_2471_digital.xlsx')
            
        rescue => exception
            Rails.logger.info "Failed to open ENT_2471_digital file: #{exception.message}"
        else
            begin
                Rails.logger.info "ENT_2471_digital File transfer complete, beginning import"

                total_count = 0
                new_count = 0
                existing_count = 0
                
                sheet = file.sheet(0)
                sheet.each(id: 'ACTVTN_CD') do |hash|
              
                  if hash[:id] != 'ACTVTN_CD'
                
                    access_code = hash[:id].to_s
                
                    if access_code.include? "."
                      access_code = access_code.split('.')[0]
                    end
                
                    # Check to see if the this access code already exists in our database
                    code = DigitalCode.where(code: access_code).first
                    if code
                        existing_count += 1
                        Rails.logger.info "Existed digital code: " + access_code
                    else
                        new_count += 1

                        params = {
                            code: access_code,
                            shopify_order_id: 0,
                            shopify_product_id: 0,
                            shopify_line_item_id: 0
                        }
                    
                        code = DigitalCode.create params
                    
                        Rails.logger.info "Imported digital code: " + access_code
                    
                    end
                
                    total_count += 1
                
                  end
              
                end
                
            rescue => exception
                Rails.logger.info "Failed to import ENT_2471_digital file: #{exception.message}"
            else
                Rails.logger.info "Import ENT_2471_digital completed successfully"
                Rails.logger.info "#{total_count} total records in file"
                Rails.logger.info "#{new_count} new records imported"
                Rails.logger.info "#{existing_count} existing records updated"
            end
        end
        
    end

end
