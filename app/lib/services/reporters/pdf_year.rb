require 'prawn/measurement_extensions'

module Services
  module Reporters
    class PdfYear < Services::Report
      delegate :present, to: :@helpers

      attr_reader :filename

      private

      # no not call super. each report has his own validate
      def validate
        @months = @context[:punches]
        @year = I18n.l((@context[:date] || Time.zone.today), format: '%Y').titleize
        @user = @context[:user]
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
        months_grid

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
              I18n.t('attributes.year').titleize,
              @year,
              "#{I18n.t('attributes.week').titleize} #{@user.week_hours} #{I18n.t('attributes.hours')}"
            ]
          ],
          cell_style: { size: 7 },
          width: 540,
          column_widths: [100, 340, 100],
          position: :center
        ) do |t|
          t.columns(1).style font_style: :bold
        end
        @pdf.move_down 8
      end

      def months_grid
        @pdf.table(
          build_months_grid,
          cell_style: { size: 7 },
          column_widths: [80] + 3.times.map { 70 } + [70] + 3.times.map { 60 },
          width: 540,
          position: :center
        ) do |t|
          t.row(0).align = :center
          t.row(0).style font_style: :bold
          t.columns(0..-1).align = :center
          t.row(-1).style font_style: :bold
          t.row(-1).columns(0..-2).align = :center
        end
      end

      def build_months_grid
        build_months_header + build_months_detail + build_punches_total
      end

      def build_months_header
        [
          [
            I18n.t('attributes.month').titleize,
            I18n.t('attributes.morning').titleize,
            I18n.t('attributes.afternoon').titleize,
            I18n.t('attributes.extra').titleize,
            I18n.t('attributes.total').upcase
          ] + Punch.statuses_i18n.values
        ]
      end

      def build_months_detail
        [].tap do |result|
          @months.each do |month, punches|
            result << [I18n.l(Date.new(@year.to_i, month, 1), format: '%B').titleize].tap do |row|
              if punches.any?
                %w[m a x].each do |c|
                  row << Punch.durations_sum(punches.map { |punch| punch.send("#{c}_duration") })
                end
                row << Punch.durations_sum(punches.map(&:total))
                statuses = Punch.statuses_count punches
                statuses.each_value { |v| row << v }
              else
                7.times { row << nil }
              end
            end
          end
        end
      end

      def build_punches_total
        [
          [
            @year,
            Punch.durations_sum(@months.values.map { |month| month.map(&:m_duration) }.flatten),
            Punch.durations_sum(@months.values.map { |month| month.map(&:a_duration) }.flatten),
            Punch.durations_sum(@months.values.map { |month| month.map(&:x_duration) }.flatten),
            Punch.durations_sum(@months.values.map { |month| month.map(&:total) }.flatten)
          ] + Punch.statuses_count(@months.values.flatten).values
        ]
      end
    end
  end
end
