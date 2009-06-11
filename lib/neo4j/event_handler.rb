module Neo4j

  # Handles events like a new node is created or deleted
  class EventHandler
    def initialize
      @listeners = []
      @filter_classes = []
    end

    def add(listener)
      @listeners << listener unless @listeners.include?(listener)
      add_filter(listener) # the listener do not want to get events on it self
    end

    def remove(listener)
      @listeners.delete(listener)
    end

    def remove_all
      @listeners = []
    end

    def add_filter(filter_class)
      @filter_classes << filter_class  unless @filter_classes.include?(filter_class)
    end
    
    def node_created(node)
      return if @filter_classes.include?(node.class)
      @listeners.each {|li| li.on_node_created(node) if li.respond_to?(:on_node_created)}
    end

    def node_deleted(node)
      return if @filter_classes.include?(node.class)
      @listeners.each {|li| li.on_node_deleted(node) if li.respond_to?(:on_node_deleted)}
    end

    def tx_finished(tx)
      @listeners.each {|li| li.on_tx_finished(tx) if li.respond_to?(:on_tx_finished)}
    end

    def neo_started(neo_instance)
      @listeners.each {|li| li.on_neo_started(neo_instance) if li.respond_to?(:on_neo_started)}
    end

    def neo_stopped(neo_instance)
      @listeners.each {|li| li.on_neo_stopped(neo_instance) if li.respond_to?(:on_neo_stopped)}
    end
  end
end