import express from "express";
import Membership from "../modals/membership.js";

const router = express.Router();

// Retrieve all memberships
router.get('/memberships', async (req, res) => {
    try {
        const memberships = await Membership.find(req.query);
        return res.status(200).json(memberships);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
});

// Retrieve a membership by ID
router.get('/memberships/:id', async (req, res) => {
    const membershipId = req.params.id;
    try {
        const membership = await Membership.findById(membershipId);
        if (!membership) {
            return res.status(404).json({ msg: 'Membership not found' });
        }
        return res.status(200).json(membership);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
});

// Create a new membership
router.post('/memberships', async (req, res) => {
    const { plan_type, plan_price, plan_validity } = req.body;
    if (!plan_type || !plan_price || !plan_validity) {
        return res.status(400).json({ msg: 'Please provide all required fields' });
    }
    try {
        const existingMembership = await Membership.findOne({ plan_type });
        if (existingMembership) {
            return res.status(400).json({ msg: 'Membership already exists' });
        }
        const newMembership = new Membership({
            plan_type,
            plan_price,
            plan_validity
        });
        await newMembership.save();
        return res.status(201).json(newMembership);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
});

// Update a membership
router.put('/memberships/:id', async (req, res) => {
    const membershipId = req.params.id;
    const { plan_type, plan_price, plan_validity } = req.body;
    if (!plan_type || !plan_price || !plan_validity) {
        return res.status(400).json({ msg: 'Please provide all required fields' });
    }
    try {
        const membership = await Membership.findById(membershipId);
        if (!membership) {
            return res.status(404).json({ msg: 'Membership not found' });
        }
        membership.plan_type = plan_type;
        membership.plan_price = plan_price;
        membership.plan_validity = plan_validity;
        await membership.save();
        return res.status(200).json(membership);
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
});

// Delete a membership
router.delete('/memberships/:id', async (req, res) => {
    const membershipId = req.params.id;
    try {
        const membership = await Membership.findByIdAndDelete(membershipId);
        if (!membership) {
            return res.status(404).json({ msg: 'Membership not found' });
        }
        return res.status(200).json({ msg: 'Membership successfully deleted' });
    } catch (err) {
        console.error('Internal Error:', err);
        return res.status(500).json({ msg: 'Internal Server Error' });
    }
});

export default router;
