class PolyTreeNode

    def initialize(value)
        @value = value
        @parent = nil
        @children = []
    end

    def value
        @value
    end

    def parent
        @parent
    end

    def children
        @children
    end

    def parent=(node_instance)
        if @parent && node_instance #truthy? parent exist and node_instance exist
            self.parent.children.reject! {|child_instance| child_instance == self}
            @parent = node_instance
            self.parent.children << self
        elsif node_instance #truthy? node_instance exist
            @parent = node_instance
            self.parent.children << self
        else
            @parent = node_instance
        end
    end

    def add_child(child_node)
        child_node.parent = self
    end

    def remove_child(child_node)
        if !self.children.include?(child_node)
            raise "Not a child node of this instance"
        end
        child_node.parent = nil
    end

    def dfs(target_value) #recursive depth-first search
        if self.value == target_value
            return self
        end

        self.children.each do |child_instance|
            y = child_instance.dfs(target_value)
            if y != nil
                return y
            end
        end
        nil
    end

    def bfs(target_value)
        queue_array = []
        queue_array << self
        until queue_array.empty?
            first_ele = queue_array.shift
            if first_ele.value == target_value
                return first_ele
            else
                queue_array += first_ele.children
            end
        end
        nil
    end

end