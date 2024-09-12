{inputs, outputs, ...}: {
    home-manager = {
        extraSpecialArgs = { inherit inputs outputs; };
        users = {
            # Import your home-manager configuration
            tht = import ../../home/tht;
        };
    };
}
