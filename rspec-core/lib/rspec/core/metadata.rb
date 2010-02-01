module Rspec
  module Core
    class Metadata < Hash

      def self.process(superclass_metadata, *args)
        new(superclass_metadata) do |metadata|
          metadata.process(*args)
        end
      end
      
      attr_reader :superclass_metadata

      def initialize(superclass_metadata=nil)
        @superclass_metadata = superclass_metadata
        update(@superclass_metadata) if @superclass_metadata
        store(:behaviour, {})
        yield self if block_given?
      end

      def process(*args)
        extra_metadata = args.last.is_a?(Hash) ? args.pop : {}
        extra_metadata.delete(:behaviour) # Remove it when present to prevent it clobbering the one we setup

        self[:behaviour][:describes] = args.shift unless args.first.is_a?(String)
        self[:behaviour][:describes] ||= self.superclass_metadata && self.superclass_metadata[:behaviour][:describes]
        self[:behaviour][:description] = args.shift || ''

        self[:behaviour][:name] = determine_name
        self[:behaviour][:block] = extra_metadata.delete(:behaviour_block)
        self[:behaviour][:caller] = extra_metadata.delete(:caller)
        self[:behaviour][:file_path] = file_path_from(self[:behaviour], extra_metadata.delete(:file_path))
        self[:behaviour][:line_number] = line_number_from(self[:behaviour], extra_metadata.delete(:line_number))
        self[:behaviour][:location] = location_from(self[:behaviour])

        update(extra_metadata)
      end

      def for_example(description, options)
        dup.configure_for_example(description,options)
      end

      def configure_for_example(description, options)
        store(:description, description.to_s)
        store(:full_description, "#{self[:behaviour][:name]} #{self[:description]}")
        store(:execution_result, {})
        store(:caller, options.delete(:caller))
        if self[:caller]
          store(:file_path, file_path_from(self))
          store(:line_number, line_number_from(self))
        end
        self[:location] = location_from(self)
        update(options)
        self
      end

      def apply_condition(filter_on, filter, metadata=nil)
        metadata ||= self
        case filter
        when Hash
          filter.all? { |k, v| apply_condition(k, v, metadata[filter_on]) }
        when Regexp
          metadata[filter_on] =~ filter
        when Proc
          filter.call(metadata[filter_on]) rescue false
        when Fixnum
          if filter_on == :line_number
            [metadata[:line_number],metadata[:behaviour][:line_number]].include?(filter)
          else
            metadata[filter_on] == filter
          end
        else
          metadata[filter_on] == filter
        end
      end

      def all_apply?(filters)
        filters.all? do |filter_on, filter|
          apply_condition(filter_on, filter)
        end
      end

    private

      def file_path_from(metadata, given_file_path=nil)
        given_file_path || file_and_line_number(metadata)[0].strip
      end

      def line_number_from(metadata, given_line_number=nil)
        given_line_number || file_and_line_number(metadata)[1].to_i
      end

      def location_from(metadata)
        "#{metadata[:file_path]}:#{metadata[:line_number]}"
      end

      def file_and_line_number(metadata)
        candidate_entries_from_caller(metadata).first.split(':')
      end

      def candidate_entries_from_caller(metadata)
        metadata[:caller].grep(/\_spec\.rb:/i)
      end

      def determine_name
        if superclass_metadata && superclass_metadata[:behaviour][:name]
          self[:behaviour][:name] = "#{superclass_metadata[:behaviour][:name]} #{self[:behaviour][:description]}".strip 
        else
          self[:behaviour][:name] = "#{self[:behaviour][:describes]} #{self[:behaviour][:description]}".strip
        end
      end

    end
  end
end
