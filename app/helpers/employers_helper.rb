module EmployersHelper
  def sortable_class(name, sorted_by, order)
    if name == sorted_by
      if order == "asc"
        "sorted-ascending"
      elsif order == "desc"
        "sorted-descending"
      end
    else
      "sorted-none"
    end
  end
end
