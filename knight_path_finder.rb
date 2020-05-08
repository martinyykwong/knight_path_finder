require_relative "./00_tree_node.rb"

class KnightPathFinder
    
    attr_reader :root_node
    attr_accessor :considered_positions

    def initialize(initial_position_arry) #[0,0] format
        if initial_position_arry[0].between?(0,7) && initial_position_arry[1].between?(0,7)
            @root_node = PolyTreeNode.new(initial_position_arry)
            @considered_positions = [initial_position_arry]
            self.build_move_tree #self is instance
        else
            raise "not a valid 8x8 chess board position"
        end
    end

    def self.valid_moves(position_array)
        row,col = position_array
        possible_positions = []
        possible_positions << [row-1, col-2]
        possible_positions << [row-2, col-1]
        possible_positions << [row-1, col+2]
        possible_positions << [row-2, col+1]
        possible_positions << [row+1, col-2]
        possible_positions << [row+2, col-1]
        possible_positions << [row+1, col+2]
        possible_positions << [row+2, col+1]
        possible_positions.reject do |pos_arr|
            pos_arr.any? {|pos| pos<0 || pos > 7}
        end
    end

    def new_move_positions(pos_arr) #return array of positions that can be moved to that haven't been counted before
        new_possible_pos_arr = KnightPathFinder.valid_moves(pos_arr).reject {|valid_move| self.considered_positions.include?(valid_move)}
        self.considered_positions += new_possible_pos_arr
        new_possible_pos_arr
    end

    def build_move_tree
        node_queue_list = [self.root_node]
        until node_queue_list.empty?
            first_node_instance = node_queue_list.shift #first node instance in queue list
            possible_next_positions = self.new_move_positions(first_node_instance.value)
            possible_next_positions.each do |new_pos|
                new_child_node = PolyTreeNode.new(new_pos)
                new_child_node.parent= first_node_instance
                node_queue_list << new_child_node
            end            
        end

    end

    def find_path(target_position)
        target_node = self.root_node.bfs(target_position) #finds the node with desired destination position
        self.trace_path_back(target_node) #backtracks to find way back to root node
    end

    def trace_path_back(end_node)
        move_path = [end_node.value]
        parent_node = end_node.parent

        until parent_node.parent == nil
            move_path << parent_node.value
            parent_node = parent_node.parent
        end
        move_path << parent_node.value
        move_path.reverse
    end

end