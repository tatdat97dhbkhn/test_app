class OrderPdf
  include Prawn::View
  def initialize
    mincho_font

    title

    move_down 20
    estimated_date

    greeting

    info_cursor = cursor
    move_down 30
    order_info

    move_cursor_to info_cursor
    company_info

    move_cursor_to cursor + 80
  end

  private

  def mincho_font
    mincho_font_path = "#{Rails.root}/app/assets/fonts/MSMINCHO.TTF"
    font_families.update(
      "ms_mincho" => {
          :normal => {:file => mincho_font_path, :font => "Mincho"},
          :bold => mincho_font_path,
          :italic => mincho_font_path,
          :bold_italic => mincho_font_path
      }
    )
    font "ms_mincho"
  end

  def title
    text "御見積書", size: 14, align: :center
  end

  def estimated_date
    current_cursor = cursor
    bounding_box([300, current_cursor], width: 200, height: 40) do
      text "№ ：", size: 8, align: :right
      move_down 10
      text "見積日 ：", size: 8, align: :right
    end
    bounding_box([510, current_cursor], width: 200, height: 40) do
      text "99999", size: 8, align: :left
      move_down 10
      text "yyyy/mm/dd", size: 8, align: :left
    end
  end

  def greeting
    text "株式会社○○○○○○○○○○○○ 御中", size: 8
  end

  def order_info
    [
      {key: '納期', value: '別途ご相談', size: 0},
      {key: '支払条件', value: '月末締翌月末払い', size: 0},
      {key: '有効期限', value: '見積発行後2週間', size: 0},
      {key: '御見積金額（税込）', value: '999,999,999円', size: 1}
    ].each do |setting|
      current_cursor = cursor
      if setting[:size] == 0
        box_height = 15
        value_size = 8
      else
        box_height = 25
        value_size = 12
      end

      bounding_box([0, current_cursor], width: 80, height: box_height) do
        stroke_color 'FFFFFF'
        stroke_bounds
        stroke do
          stroke_color 'D9D9D9'
          fill_color 'D9D9D9'
          fill_and_stroke_rectangle [bounds.left, bounds.top], bounds.right, bounds.top
          fill_color '000000'
        end
        bounds.add_right_padding 5
        bounds.add_left_padding 30
        text setting[:key], size: 8, align: :right, valign: :center
      end
      bounding_box([80, current_cursor], width: 200, height: box_height) do
        bounds.add_left_padding 5
        text setting[:value], size: value_size, align: :left, valign: :center
      end
      move_down 3
    end
  end

  def company_info
    bounding_box([400, cursor], width: 200, height: 200) do
      image "#{Rails.root}/app/assets/images/Picture1.png", at: [bounds.left, bounds.top]
      move_down 30
      text "株式会社アイコム", size: 8
      text "東京営業所", size: 8
      move_down 10
      text "〒999-9999", size: 8
      move_down 5
      text "東京都江東区木場2-17-16", size: 8
      move_down 5
      text "ビザイド木場５F", size: 8
      move_down 5
      text "TEL：99-9999-9999", size: 8
    end
  end
end
