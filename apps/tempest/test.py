def generate_plans(domain_path, problem_path, output_directory, timeout):
    from unified_planning.shortcuts import get_environment, AnytimePlanner
    from unified_planning.io import PDDLReader

    env = get_environment()
    env.factory.add_engine("tempest", "tempest.engine", "TempestEngine")
    env.credits_stream = None

    r = PDDLReader()
    problem = r.parse_problem(domain_path, problem_path)
    problem.clear_quality_metrics()

    plans_found = set()
    # 'incremental': True is faster but may generate more similar plans
    with AnytimePlanner(name="tempest", params={'incremental': False}) as p:
        for i, res in enumerate(p.get_solutions(problem, timeout=timeout)):
            if res.plan and res.plan not in plans_found:
                plans_found.add(res.plan)
                print(res.plan)
                with open(f"{output_directory}/plan_{i+1}.txt", "w") as f:
                    f.write(str(res.plan))


generate_plans("cphs_domain.pddl", "cphs_problem.pddl", ".", 10)
