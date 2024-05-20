import Foundation


class AdviceViewModel: ObservableObject {
    
    // Hardcoded advice based on clusters
    private let hardcodedAdvice = [
        FinancialAdvice(id: 0, cluster: 0, category: "Cluster 0: Saver, ConservativePlanner, BudgetEnthusiast", advice: [
            "Investments": "Focus on low-risk investments like bonds and mutual funds. Consider diversifying into dividend-paying stocks to gently increase risk exposure.",
            "Savings": "Build and maintain a robust emergency fund, aiming for 6-12 months of expenses. Explore high-interest savings accounts or CDs.",
            "Budgeting": "Regularly review and adjust budgets to ensure funds are adequately allocated toward goals and savings."
        ]),
        FinancialAdvice(id: 1, cluster: 1, category: "Cluster 1: HighEarner", advice: [
            "Investments": "Maximize contributions to retirement accounts and explore tax-efficient investment vehicles. Consider higher-risk opportunities for a portion of the portfolio to optimize growth.",
            "Savings": "Establish specific savings goals for large purchases and long-term wealth accumulation. Consider using automated savings plans to ensure consistent savings.",
            "Budgeting": "Implement a detailed budget to manage high income efficiently, focusing on maximizing investments and reducing unnecessary expenditures."
        ]),
        FinancialAdvice(id: 2, cluster: 2, category: "Cluster 2: StrugglingSpender, Newcomer, DebtManager, FrequentTraveler, Student", advice: [
            "Investments": "Start with low-risk investments. For those with debt, focus on debt repayment before investing significantly.",
            "Savings": "Prioritize building a small emergency fund, even if it’s a modest amount each month. Use tools like rounding up transactions to save effortlessly.",
            "Budgeting": "Use budgeting apps to track spending meticulously. Identify areas to cut costs and improve financial management skills."
        ]),
        FinancialAdvice(id: 3, cluster: 3, category: "Cluster 3: RiskTaker", advice: [
            "Investments": "Allocate a significant portion of the portfolio to high-risk, high-reward investments like stocks or cryptocurrencies, balanced with stable investments.",
            "Savings": "Maintain a solid emergency fund to buffer the financial volatility from high-risk investments.",
            "Budgeting": "Regularly assess financial risks and adjust budgets to accommodate investment strategies and potential losses."
        ]),
        FinancialAdvice(id: 4, cluster: 4, category: "Cluster 4: AspiringInvestor", advice: [
            "Investments": "Educate on a variety of investment types, emphasizing long-term strategies and the importance of diversification.",
            "Savings": "Aim for progressive savings goals that increase as investment knowledge and income grow.",
            "Budgeting": "Focus on creating a budget that allocates a fixed percentage to investments monthly."
        ]),
        FinancialAdvice(id: 5, cluster: 5, category: "Cluster 5: RetirementPlanner", advice: [
            "Investments": "Focus on securing stable, income-producing investments. Evaluate annuities or other fixed-income options suitable for retirement.",
            "Savings": "Continue to maximize retirement savings contributions, especially to tax-advantaged accounts.",
            "Budgeting": "Plan for upcoming healthcare costs and other retirement-related expenses."
        ]),
        FinancialAdvice(id: 6, cluster: 6, category: "Cluster 6: YoungProfessional", advice: [
            "Investments": "Start with a mix of medium-risk assets. Consider using robo-advisors for beginning investments.",
            "Savings": "Establish good saving habits early, like saving for retirement and major life events.",
            "Budgeting": "Develop a comprehensive budget that includes student loans, housing, and discretionary spending."
        ]),
        FinancialAdvice(id: 7, cluster: 7, category: "Cluster 7: SeasonedExecutive", advice: [
            "Investments": "Leverage advanced investment strategies and opportunities. Consider private equity or executive investment plans.",
            "Savings": "Focus on legacy planning and wealth transfer strategies, including trusts and estate planning.",
            "Budgeting": "Maintain a budget that supports wealth accumulation and charitable giving strategies."
        ]),
        FinancialAdvice(id: 8, cluster: 8, category: "Cluster 8: RealEstateInvestor", advice: [
            "Investments": "Continue to identify and capitalize on real estate opportunities, possibly diversifying into commercial properties or real estate funds.",
            "Savings": "Keep a reserve fund specifically for property maintenance and unforeseen real estate market fluctuations.",
            "Budgeting": "Allocate funds for property investments, maintenance, and potential tax implications."
        ]),
        FinancialAdvice(id: 9, cluster: 9, category: "Cluster 9: TechEnthusiast", advice: [
            "Investments": "Explore emerging tech startups, venture capital opportunities, and tech ETFs. Stay informed about technological advancements and invest accordingly.",
            "Savings": "Consider setting aside funds for attending tech conferences or further education in emerging technologies.",
            "Budgeting": "Prioritize expenses towards technology upgrades and educational investments."
        ])
    ]

    func fetchAdvice(for identifier: Int) -> FinancialAdvice? {
           return hardcodedAdvice.first(where: { $0.cluster == identifier })
       }
           
    func rateAdvice(user: inout UserProfileInfoModel, adviceId: Int, category: String, rating: Int) {
        if let advice = fetchAdvice(for: adviceId), advice.id == adviceId {
            user.updateRating(adviceId: advice.id, category: category, rating: rating)
        }
    }
       
    func getRating(for user: UserProfileInfoModel, adviceId: Int, category: String) -> Int? {
        return user.adviceRatings[adviceId]?[category]
    }
}
