# test IG

- get container with IG pub running
- can we put liquid tags in StructureDefinition.description?
- mess around with templates, like, for real
  - start by simply making a very simple one and then using it
- how can we get css classes into markdown?  We can't.... :-(


Do this in the top level folder of where your IG is:
docker run -it --name v2pub -v "$(pwd)":/ig v2ig-pub

docker run -it --name <other_container_name> -v "$(pwd)":/ig v2ig-pub

