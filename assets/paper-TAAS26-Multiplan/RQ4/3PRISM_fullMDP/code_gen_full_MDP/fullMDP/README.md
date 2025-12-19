# Create full MDP Prism files

Modify in ```runFullMDP.py``` the path to the JSON file in variable ```input_dir```

Then run ```runFullMDP.py``` python script

It will generate in the JSON file folder another folder with two MDP PRISM files:
- one with retries implicit*
- a second with explicit retries**

In both, the scheduling of tasks are represented as (non-deterministic) MDP actions.

* = probabilities of failure and success per retry added without actions--in PRISM the policy does not return the num. of retries to take, but can be verified for the max. probability of success or min. cost.

** = retries are actions; the return policy includes the best number of actions to take; the max. probability of success or min. cost returns the same values as the previous MDP.