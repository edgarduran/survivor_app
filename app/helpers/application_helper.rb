module ApplicationHelper
  FLASH_CLASSES = {
    "notice"  => "bg-green-100 text-green-800 border-b border-green-200",
    "alert"   => "bg-red-100 text-red-800 border-b border-red-200",
    "info"    => "bg-blue-100 text-blue-800 border-b border-blue-200",
    "warning" => "bg-yellow-100 text-yellow-800 border-b border-yellow-200"
  }.freeze

  def flash_class(type)
    FLASH_CLASSES.fetch(type.to_s, "bg-gray-100 text-gray-800 border-b border-gray-200")
  end
end
