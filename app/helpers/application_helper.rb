module ApplicationHelper
  def full_title page_title = ""
    base_title = t "base_title"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title	
    end
  end

  def link_to_add_fields name, f, association
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render "admin/words/" + association.to_s.singularize + "_fields", f: builder
    end
    link_to name, "", class: "add_fields label label-success", data: {id: id,
      fields: fields.gsub("\n", "")}
  end

  def find_user user_id
    User.find user_id
  end

  def find_lesson lesson_id
    Lesson.find lesson_id
  end
end
