## Representation of Adjacency List
Within the adjacency list there are a number of nodes for which there is not a parent, i.e. more than one tree is represented by the data, and there are also nodes having more than two children.

For the first part of the exercise, I was asked to create an API that would be able to ingest two nodes IDs and return the root node, least common ancestor, and depth of that ancestral node. Being given a list in (ID, parent ID) form, we are able to find any node's parent in constant time with a Hash lookup. This is done here with Ruby's built-in Hash object, however, other key value stores that are more suited to large volumes of data could be used when are large volume of data is expected.

The constant time lookup of each node's parent is used to climb up the tree until a root is reached. This is done for each of the two nodes received in the request to the `/common_ancestor` endpoint. Having collected, in the form of two arrays, the paths from each of the two nodes to the root, we are able to find the node at which the paths have converged, i.e. their lowest common ancestor, as well as the depth of that node by considering the remaining nodes in the list leading to the root.

## Birds
A separate class was created to contain the information related to which node any bird belongs to. In contradistinction to the previous case where we wanted to obtain information regarding two nodes common ancestor, here we need to descend the tree, collecting the IDs of the birds sitting at any node along the way.

This was accomplished by adding an additional Hash data structre to the `AdacencyList` class, with keys being parent IDs and the values being an array of that parent's children. Similarly as before, access to this information is in constant time.

Now being able to descend the tree we can collect the bird IDs as we recursively traverse the children in the downward direction.

As there is no guarantee that the list of node IDs received in a request to `/birds` does not contain descendants of any other of the nodes, I chose to store a reference to the nodes already visited and skip the process of gathering bird IDs when we arrive at one of those nodes.

## How to Run
```
bundle install
ruby server.rb
```
Then make requests to `http://localhost:4567/`. For example:
```
GET http://localhost:4567/common_ancestor?a=2&b=3

GET http://localhost:4567/birds?nodes=[2]
```
`server.rb` is set up to load in the `nodes.csv` file that was included in the attachments sent for the exercise. `birds.csv` is also loaded, however, that is "dummy" data I created to check my work along the way, and it will need to be replaced by a more appropriate file where the birds belong to real nodes from `nodes.csv`.
## How to Run Specs
`rspec dataplor_spec.rb`
