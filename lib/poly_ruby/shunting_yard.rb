require "strscan"
require "poly_ruby/monomial"

class Array
  alias_method :enqueue, :push
  alias_method :dequeue, :shift
end

class ShutingYard

  def op_preced(c)
    case c
    when '^', '**'
      return 4
    when '*', '/', '%'
      return 3
    when '+', '-'
      return 2
    when '='
      return 1
    end
    return 0
  end

  def op_left_assoc(c)
    case c
    when '*', '/', '%', '+', '-'
      return true
    when '=', '^', '**'
      return false
    end
    return false
  end

  def op_arg_count(c)
    case c
    when '*', '/', '%', '+', '-', '='
      return 2
    when '^', '**'
      return 1
    end
    return 0
  end

  def tokenize(str)
    @tokens = []
    s = StringScanner.new(str)

    until s.eos?
      case
      when s.scan(/\s+/)
      when s.scan(/\*\*|\^/)
        @tokens.push [:OP, s.matched]
      when s.scan(/[\+\-\*\/!%=]/)
        @tokens.push [:OP, s.matched]
      when s.scan(/\d+/)
        @tokens.push [:NUM, s.matched]
      when s.scan(/[a-zA-Z_][_a-zA-Z0-9]*/)
        @tokens.push [:VAR, s.matched]
      when s.scan(/.|\n/o)
        @tokens.push [s.matched, s.matched]
      else
        raise "scanner error"
      end
    end
    return @tokens
  end

  def parse(tokens)
    @out_queue = []
    @op_stack = []

    while not tokens.empty?
      token = tokens.dequeue

      case
      when token.first == :NUM
        @out_queue.enqueue token.last
      when token.first == :VAR
        @out_queue.enqueue token.last
      when token.first == :OP
        op1 = token.last
        while not @op_stack.empty?
          op2 = @op_stack.last
          if (op_left_assoc(op1) && (op_preced(op1) <= op_preced(op2))) or
            (op_preced(op1) < op_preced(op2))
            # Pop op2 off the stack, onto the output queue;
            @out_queue.enqueue(@op_stack.pop)
          else
            break
          end
        end
        @op_stack.push(op1)
      when token.first == '('
        @op_stack.push(token.last)
      when token.first == ')'
        pe = false
        while not @op_stack.empty?
          sc = @op_stack.pop
          if sc == '('
            pe = true
            break
          else
            @out_queue.enqueue(sc)
          end
        end
        if !pe
          raise "parser error"
        end
      else
        raise "parser error"
      end
    end

    while not @op_stack.empty?
      @out_queue.enqueue(@op_stack.pop)
    end

    return @out_queue
  end
end
