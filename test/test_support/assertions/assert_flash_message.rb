module Minitest::Assertions

  def assert_flash_message
    check_flash_by_selector '.Flash'
  end

  def assert_positive_flash_message
    check_flash_by_selector '.Flash .positive'
  end

  def assert_negative_flash_message
    check_flash_by_selector '.Flash .negative'
  end

  private

  def check_flash_by_selector selector
    page.must_have_selector(selector)
    page.find(selector).text.wont_be_empty
    page.find(selector).text.wont_include('translation missing:')
  end

end