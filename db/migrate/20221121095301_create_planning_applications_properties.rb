class CreatePlanningApplicationsProperties < ActiveRecord::Migration[7.0]
  def up
    # create join table
    create_table :planning_applications_properties do |t|
      t.references :planning_application, foreign_key: true, index: { name: :idx_planning_applications_properties_on_planning_application }
      t.references :property, foreign_key: true, index: { name: :idx_planning_applications_properties_on_property }

      t.timestamps
    end

    # populate join table with existing data
    puts "populating planning_applications_properties"
    PlanningApplication.all.each do |planning_application|
      puts "#{planning_application.reference} is being added to the planning_applications_properties table"
      PlanningApplicationsProperty.create(planning_application_id: planning_application.id, property_id: planning_application.property_id)
      puts "There are #{PlanningApplicationsProperty.count} planning_applications_properties records"
    end

    # remove obsolete column
    puts "removing old association"
    remove_reference :planning_applications, :property
  end

  def down
    # add reference column back
    add_reference :planning_applications, :property

    # Using a model after changing its table
    # https://api.rubyonrails.org/classes/ActiveRecord/Migration.html#class-ActiveRecord::Migration-label-Using+a+model+after+changing+its+table
    PlanningApplication.reset_column_information

    # associate planning_application with property, even though it will just be one.
    PlanningApplicationsProperty.all.each do |planning_application_property|
      PlanningApplication.find(planning_application_property.planning_application_id).update_attribute(:property_id, planning_application_property.property_id)
    end

    # remove join table
    drop_table :planning_applications_properties
  end
end
