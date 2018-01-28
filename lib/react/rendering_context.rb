module React
  class RenderingContext
    class << self
      attr_accessor :waiting_on_resources

      def render(name, *args, &block)
        was_outer_most = !@not_outer_most
        @not_outer_most = true
        remove_nodes_from_args(args)
        @buffer ||= [] unless @buffer
        if block
          element = build do
            saved_waiting_on_resources = waiting_on_resources
            self.waiting_on_resources = nil
            run_child_block(name.nil?, &block)
            if name
              buffer = @buffer.dup
              React::API.create_element(name, *args) { buffer }.tap do |element|
                element.waiting_on_resources = saved_waiting_on_resources || !!buffer.detect { |e| e.waiting_on_resources if e.respond_to?(:waiting_on_resources) }
                element.waiting_on_resources ||= waiting_on_resources if buffer.last.is_a?(String)
              end
            elsif @buffer.last.is_a? React::Element
              @buffer.last.tap { |element| element.waiting_on_resources ||= saved_waiting_on_resources }
            else
              buffer_s = @buffer.last.to_s
              React::RenderingContext.render(:span) { buffer_s }.tap { |element| element.waiting_on_resources = saved_waiting_on_resources }
            end
          end
        elsif name.is_a? React::Element
          element = name
        else
          element = React::API.create_element(name, *args)
          element.waiting_on_resources = waiting_on_resources
        end
        @buffer << element
        self.waiting_on_resources = nil
        element
      ensure
        @not_outer_most = @buffer = nil if was_outer_most
      end

      def build
        current = @buffer
        @buffer = []
        return_val = yield @buffer
        @buffer = current
        return_val
      end

      def delete(element)
        @buffer.delete(element)
        element
      end
      alias as_node delete

      def rendered?(element)
        @buffer.include? element
      end

      def replace(e1, e2)
        @buffer[@buffer.index(e1)] = e2
      end

      def remove_nodes_from_args(args)
        args[0].each do |key, value|
          begin
            value.delete if value.is_a?(Element) # deletes Element from buffer
          rescue Exception
          end
        end if args[0] && args[0].is_a?(Hash)
      end

      # run_child_block gathers the element(s) generated by a child block.
      # for example when rendering this div: div { "hello".span; "goodby".span }
      # two child Elements will be generated.
      #
      # the final value of the block should either be
      #   1 an object that responds to :acts_as_string?
      #   2 a string,
      #   3 an element that is NOT yet pushed on the rendering buffer
      #   4 or the last element pushed on the buffer
      #
      # in case 1 we change the object to a string, and then it becomes case 2
      # in case 2 we automatically push the string onto the buffer
      # in case 3 we also push the Element onto the buffer IF the buffer is empty
      # case 4 requires no special processing
      #
      # Once we have taken care of these special cases we do a check IF we are in an
      # outer rendering scope.  In this case react only allows us to generate 1 Element
      # so we insure that is the case, and also check to make sure that element in the buffer
      # is the element returned

      def run_child_block(is_outer_scope)
        result = yield
        if result.respond_to?(:acts_as_string?) && result.acts_as_string?
          @buffer << result.to_s
        elsif result.is_a?(String) || (result.is_a?(React::Element) && @buffer.empty?)
          @buffer << result
        end
        raise_render_error(result) if is_outer_scope && @buffer != [result]
      end

      # heurestically raise a meaningful error based on the situation

      def raise_render_error(result)
        improper_render 'A different element was returned than was generated within the DSL.',
                        'Possibly improper use of Element#delete.' if @buffer.count == 1
        improper_render "Instead #{@buffer.count} elements were generated.",
                        'Do you want to wrap your elements in a div?' if @buffer.count > 1
        improper_render "Instead the component #{result} was returned.",
                        "Did you mean #{result}()?" if result.try :reactrb_component?
        improper_render "Instead the #{result.class} #{result} was returned.",
                        'You may need to convert this to a string.'
      end

      def improper_render(message, solution)
        raise "a component's render method must generate and return exactly 1 element or a string.\n"\
              "    #{message}  #{solution}"
      end
    end
  end
end

class Object
  [:span, :td, :th, :while_loading].each do |tag|
    define_method(tag) do |*args, &block|
      args.unshift(tag)
      return send(*args, &block) if is_a? React::Component
      React::RenderingContext.render(*args) { to_s }
    end
  end

  def para(*args, &block)
    args.unshift(:p)
    return send(*args, &block) if is_a? React::Component
    React::RenderingContext.render(*args) { to_s }
  end

  def br
    return send(:br) if is_a? React::Component
    React::RenderingContext.render(:span) do
      React::RenderingContext.render(to_s)
      React::RenderingContext.render(:br)
    end
  end
end
