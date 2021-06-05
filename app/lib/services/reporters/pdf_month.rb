require 'prawn/measurement_extensions'

module Services
  module Reporters
    class PdfMonth < Services::Report
      delegate :present, to: :@helpers

      attr_reader :filename

      private

      # no not call super. each report has his own validate
      def validate
        @punches = @context[:punches]
        @month = I18n.l((@context[:date] || Time.zone.today), format: '%B %Y').titleize
        @user = @context[:user]
        # "date_start"=>"Mon Oct 15 2018 00:00:00 GMT+0200",
        # "date_end"=>"Sun Oct 21 2018 23:59:59 GMT+0200",
        # "kind"=>"user"
        # errors.add :error, 'Bad params!' unless ...
      end

      # no not call super. each report has his own execute
      def execute
        @filename = Tempfile.new(@user.id)
        build_file
      end

      def build_file
        font_path = Rails.root.join('app', 'assets', 'fonts')
        @pdf = Prawn::Document.new top_margin: 8.mm, bottom_margin: 10.mm do
          font_families['Arial'] =
            {
              normal: { font: 'arial', file: Rails.root.join(font_path, 'arial.ttf') },
              italic: { font: 'arial_italic', file: Rails.root.join(font_path, 'arial_italic.ttf') },
              bold: { font: 'arial_bold', file: Rails.root.join(font_path, 'arial_bold.ttf') },
              bold_italic: { font: 'arial_bold_italic', file: Rails.root.join(font_path, 'arial_bold_italic.ttf') }
            }
          font 'Arial'
        end

        page_header
        punches_grid

        @pdf.render_file @filename
      end

      def page_header
        @pdf.font_size = 16
        @pdf.text(
          'REGISTRO DE LA JORNADA DE LOS TRABAJADORES',
          align: :center
        )
        @pdf.font_size = 10
        @pdf.text(
          'En cumplimiento de la obligación establecida en el RDL 8/2019 Capitulo III Art. 10',
          align: :center
        )
        @pdf.move_down 8

        @pdf.table(
          [
            [
              I18n.t('attributes.company').titleize,
              @user.company.name,
              @user.company.vat_number
            ],
            [
              I18n.t('attributes.employee').titleize,
              @user.name,
              @user.vat_number
            ],
            [
              I18n.t('attributes.month').titleize,
              @month,
              "#{I18n.t('attributes.week').titleize} #{@user.week_hours} #{I18n.t('attributes.hours')}"
            ]
          ],
          cell_style: { size: 7 },
          width: 550,
          column_widths: [100, 350, 100],
          position: :center
        ) do |t|
          t.columns(1).style font_style: :bold
        end
        @pdf.move_down 8
      end

      def punches_grid
        @pdf.table(
          build_punches_grid,
          cell_style: { size: 7 },
          column_widths: [168] + 9.times.map { 40 } + [40],
          width: 568,
          position: :center
        ) do |t|
          t.row(0).align = :center
          t.rows(0..1).style font_style: :bold
          t.columns(0..-2).align = :center
          t.column(-1).align = :right
          t.row(-1).style font_style: :bold
          t.row(-1).columns(0..-2).align = :center
        end
      end

      def build_punches_grid
        build_punches_header + build_punches_detail + build_punches_total
      end

      def build_punches_header
        [
          [
            '',
            { content: I18n.t('attributes.morning').titleize, colspan: 3 },
            { content: I18n.t('attributes.afternoon').titleize, colspan: 3 },
            { content: I18n.t('attributes.extra').titleize, colspan: 3 },
            ''
          ],
          [I18n.t('attributes.date').titleize] +
            (3.times.map do
              [
                I18n.t('attributes.begin').titleize,
                I18n.t('attributes.end').titleize,
                I18n.t('attributes.total').titleize
              ]
            end).flatten +
            [I18n.t('attributes.total').upcase]
        ]
      end

      def build_punches_detail
        [].tap do |result|
          @punches.order(:date).each do |model|
            present(model) do |punch|
              date = punch.date_with_status
              date += "\n#{punch.note}" if punch.note.present?
              result <<
                [date] +
                (%w[m a x].each.map do |c|
                  [
                    punch.send("#{c}_begin"),
                    punch.send("#{c}_end_running_print"),
                    punch.send("#{c}_duration")
                  ]
                end).flatten +
                [punch.total]
            end
          end
        end
      end

      def build_punches_total
        [
          [
            { content: @month, colspan: 3 },
            Punch.durations_sum(@punches.map(&:m_duration)),
            { content: '', colspan: 2 },
            Punch.durations_sum(@punches.map(&:a_duration)),
            { content: '', colspan: 2 },
            Punch.durations_sum(@punches.map(&:x_duration)),
            Punch.durations_sum(@punches.map(&:total))
          ]
        ]
      end
    end
  end
end
