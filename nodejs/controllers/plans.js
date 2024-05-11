import express from "express";
import Plan from "../modals/plans.js";

const router = express.Router();

// Retrieve all plans
const getPlans = async (req, res) => {
    try {
        const plans = await Plan.find({});
        return res.status(200).json(plans);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

// Retrieve a plan by ID
const getPlan = async (req, res) => {
    const  { id }  = req.body;
    try {
        const plan = await Plan.findById(id);
        if (!plan) {
            return res.status(404).json({ msg: 'Plan not found' });
        }
        return res.status(200).json(plan);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

// Create a new plan
const createPLan = async (req, res) => {
    const { plan_type, plan_price, plan_validity } = req.body;
    if (!plan_type || !plan_price || !plan_validity) {
        return res.status(400).json({ msg: 'Please provide all required fields' });
    }
    try {
        const existingPlan = await Plan.findOne({ plan_type });
        if (existingPlan) {
            return res.status(400).json({ msg: 'Plan already exists' });
        }
        const newPlan = new Plan({
            plan_type,
            plan_price,
            plan_validity
        });
        await newPlan.save();
        return res.status(201).json(newPlan);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

// Update a plan
const updatePlan =  async (req, res) => {

    const { plan_type, plan_price, plan_validity , id } = req.body;
    if (!plan_type || !plan_price || !plan_validity || !id) {
        return res.status(400).json({ msg: 'Please provide all required fields' });
    }
    try {
        const plan = await Plan.findById(id);
        if (!plan) {
            return res.status(404).json({ msg: 'Plan not found' });
        }
        plan.plan_type = plan_type;
        plan.plan_price = plan_price;
        plan.plan_validity = plan_validity;
        await plan.save();
        return res.status(200).json(plan);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

// Delete a plan
const deletePlan =  async (req, res) => {
    const  { id }  = req.body;
    try {
        const plan = await Plan.findByIdAndDelete(id);
        if (!plan) {
            return res.status(404).json({ msg: 'Plan not found' });
        }
        return res.status(200).json({ msg: 'Plan successfully deleted' });
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
};

export { getPlan , getPlans , createPLan , updatePlan , deletePlan };
