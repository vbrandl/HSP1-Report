# Node Ranking

## Problem

The problem is to find sensors, crawlers, other researchers and <polizei> in P2P botnets.
P2P botnets can be modeled as a directed graph $G = (V, E)$.
These are hard to monitor due to the missing central authority and must be mapped over time to get an image of the size and members of the botnet.
In the scope of this project, we try to find sensors by ranking nodes in the graph using different graph-ranking algorithms:

* PageRank:
    the same algorithm google uses to rank search results. Nodes in the graph are ranked depending on their $\deg_{in}$ and $\deg_{out}$

    With $rank_v$ being the current rank of $v \in V$, $pred_v$ being the predecessors of $v \in V$ and $succ_v$ being the successors von $v \in V$ and a freely choosable dampingFactor (TODO), PageRank for $v$ is defined as
    
    $$
    (\sum\limits_{p \in pred_v} \frac{rank_p}{|succ_p|}) * dampingFactor + \frac{1 - dampingFactor}{|V|}
    $$

* SensorRank:
    based on page rank

    $$
    SensorRank_v = edge-weight_v \times \frac{pred_v}{V}
    $$

* sensor buster
    find weakly connected components in the graph since the sensors should have many incoming but few to none outgoing edges with makes them a single component

    While monitoring a P2P botnet requires the sensor to be part of the network, at the same time one does not want to help the network in any malicious activity. Therefore sensors will accept incoming connections but neither execute commands by the botmaster, nor reply accurratly to neigbourhood list requests. This behaviour results in the disconnected graph component.


### Requirements


## Existing System: BMS

The Botnet Monitoring System (BMS) is a platform to crawl and monitor P2P botnets and building statistics over time.
Currently the following botnets are being watched:

* DDG: Mining botnet, aimed at database servers
* Hajime: IoT botnet, related to Mirai (?)
* Hide 'n' Seek: IoT and database servers, crytocurrency mining
* Mozi: IoT, DDoS, data exfiltration
* Sality: Windows, spam, proxy, data exfiltration, DDoS


## Implementation

The solution has been implemented as a scheduler in python running in a Docker container alongside the other processes of BMS.

One of the system's tables called `bot_edges` contains each known edge in the botnet graph consisting of IP address, port and bot ID (if available) of the source and destination bots as well as the time, when the edge has been found.
This table allows to build the network graph for a defined time frame.

The scheduler takes time frames of 1h, builds the network graph over all the edges in that frame, applies the 3 ranking algorithms and persists the result.
Only the top x% or y nodes (both of which are configurable) of the ranked nodes are persisted to keep the memory footprint as low as possible.


### Testing and Verification of Results

Some unit tests were implemented to verify the result of the rankings, where the input and expected output are known:

* A complete graph was generated and fake sensor nodes with only incoming edges were inserted into the graph. The ranking algorithms are then executed on the graph and we checked if the fake sensor was found.
* Inputs for which the expected result is known were generated and used to test the algorithms
* On production data, we verified, that well known sensors were found by our implementation


### Failed Attempts

* view/materialized view


## References

@inproceedings{andriesseReliableReconAdversarial2015,
  title = {Reliable {{Recon}} in {{Adversarial Peer}}-to-{{Peer Botnets}}},
  booktitle = {Proceedings of the 2015 {{Internet Measurement Conference}}},
  author = {Andriesse, Dennis and Rossow, Christian and Bos, Herbert},
  date = {2015-10-28},
  series = {{{IMC}} '15},
  pages = {129--140},
  publisher = {{Association for Computing Machinery}},
  location = {{New York, NY, USA}},
  doi = {10.1145/2815675.2815682},
  url = {https://doi.org/10.1145/2815675.2815682},
  urldate = {2021-03-23},
  abstract = {The decentralized nature of Peer-to-Peer (P2P) botnets precludes traditional takedown strategies, which target dedicated command infrastructure. P2P botnets replace this infrastructure with command channels distributed across the full infected population. Thus, mitigation strongly relies on accurate reconnaissance techniques which map the botnet population. While prior work has studied passive disturbances to reconnaissance accuracy ---such as IP churn and NAT gateways---, the same is not true of active anti-reconnaissance attacks. This work shows that active attacks against crawlers and sensors occur frequently in major P2P botnets. Moreover, we show that current crawlers and sensors in the Sality and Zeus botnets produce easily detectable anomalies, making them prone to such attacks. Based on our findings, we categorize and evaluate vectors for stealthier and more reliable P2P botnet reconnaissance.},
  isbn = {978-1-4503-3848-6},
  keywords = {crawling,peer-to-peer botnet,reconnaissance},
  file = {/home/me/Zotero/storage/KWGUA89Y/Andriesse et al. - 2015 - Reliable Recon in Adversarial Peer-to-Peer Botnets.pdf}
}

@inproceedings{karuppayahSensorBusterIdentifyingSensor2017,
  title = {{{SensorBuster}}: On {{Identifying Sensor Nodes}} in {{P2P Botnets}}},
  shorttitle = {{{SensorBuster}}},
  booktitle = {Proceedings of the 12th {{International Conference}} on {{Availability}}, {{Reliability}} and {{Security}}},
  author = {Karuppayah, Shankar and Böck, Leon and Grube, Tim and Manickam, Selvakumar and Mühlhäuser, Max and Fischer, Mathias},
  date = {2017-08-29},
  series = {{{ARES}} '17},
  pages = {1--6},
  publisher = {{Association for Computing Machinery}},
  location = {{New York, NY, USA}},
  doi = {10.1145/3098954.3098991},
  url = {https://doi.org/10.1145/3098954.3098991},
  urldate = {2021-03-23},
  abstract = {The ever-growing number of cyber attacks originating from botnets has made them one of the biggest threat to the Internet ecosystem. Especially P2P-based botnets like ZeroAccess and Sality require special attention as they have been proven to be very resilient against takedown attempts. To identify weaknesses and to prepare takedowns more carefully it is thus a necessity to monitor them by crawling and deploying sensor nodes. This in turn provokes botmasters to come up with monitoring countermeasures to protect their assets. Most existing anti-monitoring countermeasures focus mainly on the detection of crawlers and not on the detection of sensors deployed in a botnet. In this paper, we propose two sensor detection mechanisms called SensorRanker and SensorBuster. We evaluate these mechanisms in two real world botnets, Sality and ZeroAccess. Our results indicate that SensorRanker and SensorBuster are able to detect up to 17 sensors deployed in Sality and four within ZeroAccess.},
  isbn = {978-1-4503-5257-4},
  keywords = {Anti-monitoring,Countermeasure,Detection,P2P Botnet,Sensor},
  file = {/home/me/Zotero/storage/ZDUFTXYY/Karuppayah et al. - 2017 - SensorBuster On Identifying Sensor Nodes in P2P B.pdf}
}

