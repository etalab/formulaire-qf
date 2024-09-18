class CollectivityDecorator < SimpleDelegator
  def display_name
    "#{name} (#{departement})"
  end

  def select_name
    "(#{departement}) #{name}"
  end
end
