from pathlib import Path

from ansible.plugins.inventory import BaseInventoryPlugin, Constructable
from ansible.inventory.data import InventoryData
from ansible.parsing.dataloader import DataLoader
from jinja2 import Environment, PackageLoader, select_autoescape


class InventoryModule(BaseInventoryPlugin, Constructable):
    NAME = 'jinja_yaml'

    def parse(self, inventory: InventoryData, loader: DataLoader, path: str, cache: bool = True):
        # Parse the inventory file
        super(InventoryModule, self).parse(inventory, loader, path)
        raw_data = loader.load_from_file(path)
        var_file = raw_data["varfile"]
        vars_ = loader.load_from_file(var_file)
        
         
        env = Environment()
        with Path(path).open("r") as f:
            content = f.read()

        template = env.from_string(content)
        rendered_inventory = template.render(**vars_)
        
        inventory = loader.load(rendered_inventory)
        for group, group_value in inventory.items():
            if group in {"plugin", "varfile"}:
                continue
            self.inventory.add_group(group)
            hosts = group_value.get("hosts", {}).keys()
            for host in hosts:

                self.inventory.add_host(host, group=group)
                for name, value in inventory[group]["hosts"].get(host, {}).items():
                    self.inventory.set_variable(host, name, value)
